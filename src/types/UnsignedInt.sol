// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { ArithmeticLib } from "../libraries/ArithmeticLib.sol";

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
    function convertWithSize(UnsignedInt u, uint16 desiredBits) public pure returns (uint256 to) {
        bytes32 result = ArithmeticLib.convertWithSize(UnsignedInt.unwrap(u), desiredBits, sizeInBits(u));

        assembly {
            to := result
        }
    }

    function sizeInBits(UnsignedInt u) public pure returns (uint16 size) {
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
}
