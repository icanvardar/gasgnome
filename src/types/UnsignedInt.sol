// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

type UnsignedInt is bytes32;

using {
    addUnsignedInt as +,
    subUnsignedInt as -,
    mulUnsignedInt as *,
    divUnsignedInt as /,
    modUnsignedInt as %,
    expUnsignedInt as ^
} for UnsignedInt global;

function addUnsignedInt(UnsignedInt left, UnsignedInt right) pure returns (UnsignedInt res) {
    assembly {
        res := add(left, right)

        if lt(res, left) {
            /// TODO: add custom error here - overflow check
            revert(0x00, 0x00)
        }
    }
}

function subUnsignedInt(UnsignedInt left, UnsignedInt right) pure returns (UnsignedInt res) {
    assembly {
        if gt(right, left) {
            /// TODO: add custom error here - underflow check
            revert(0x00, 0x00)
        }

        res := sub(left, right)
    }
}

function mulUnsignedInt(UnsignedInt left, UnsignedInt right) pure returns (UnsignedInt res) {
    assembly {
        switch or(iszero(left), iszero(right))
        case 0 { res := 0 }
        case 1 { res := mul(left, right) }
    }
}

function divUnsignedInt(UnsignedInt left, UnsignedInt right) pure returns (UnsignedInt res) {
    assembly {
        if eq(right, 0) {
            /// TODO: add custom error here - division by zero check
            revert(0x00, 0x00)
        }

        res := div(left, right)
    }
}

function modUnsignedInt(UnsignedInt left, UnsignedInt right) pure returns (UnsignedInt res) {
    assembly {
        if iszero(right) {
            /// TODO: add custom error here - modulo by zero check
            revert(0x00, 0x00)
        }

        res := mod(left, right)
    }
}

function expUnsignedInt(UnsignedInt left, UnsignedInt right) pure returns (UnsignedInt res) {
    assembly {
        res := exp(left, right)
    }
}

using UnsignedIntLib for UnsignedInt global;

library UnsignedIntLib {
    function convertWithSize(UnsignedInt u, uint16 sizeInBytes) public pure returns (uint256 to) {
        assembly {
            /// TODO: add custom error here - sizeInBytes cannot be zero/cannot be bigger than 256 bits
            if or(eq(sizeInBytes, 0), gt(sizeInBytes, 0x100)) { revert(0x00, 0x00) }

            /// TODO: add custom error here - sizeInBytes has to be multiple of eight
            if gt(mod(sizeInBytes, 0x8), 0) { revert(0x00, 0x00) }
        }

        uint8 sizeCap = cap(sizeInBits(u));

        assembly {
            /// TODO: add custom error here - size cap cannot be bigger than given size in bytes
            if gt(sizeCap, sizeInBytes) { revert(0x00, 0x00) }

            to := u
        }
    }

    function sizeInBits(UnsignedInt u) public pure returns (uint8 size) {
        assembly {
            let tmp
            for { let i := 0x1f } gt(i, 0x0) { i := sub(i, 1) } {
                let b := byte(i, u)

                /// NOTE: check existency of first nibble
                let x := and(b, 0x0f)
                if gt(x, 0) {
                    size := add(size, add(tmp, 0x1))
                    tmp := 0x0
                }
                if eq(x, 0) { tmp := add(tmp, 0x1) }

                /// NOTE: check existency of second nibble
                let y := and(b, 0xf0)
                if gt(y, 0) { size := add(size, 0x1) }
                if eq(y, 0) { tmp := add(tmp, 0x1) }
            }

            size := mul(size, 0x4)
        }
    }

    /// NOTE: finds the nearest bit cap in multiple of eight
    function cap(uint8 bitSize) public pure returns (uint8 res) {
        assembly {
            for { let i := 0x0 } lt(i, 0x21) { i := add(i, 1) } {
                let tmp := mul(add(i, 1), 8)
                if or(gt(tmp, bitSize), eq(tmp, bitSize)) {
                    res := tmp
                    break
                }
            }
        }
    }
}
