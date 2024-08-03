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
            /// @dev bytes4(keccak256("Overflow()")) => 0x35278d12
            mstore(0x80, 0x35278d12)
            revert(0x9c, 0x04)
        }
    }
}

function subUnsignedInt(UnsignedInt left, UnsignedInt right) pure returns (UnsignedInt res) {
    assembly {
        if gt(right, left) {
            /// @dev bytes4(keccak256("Underflow()")) => 0xcaccb6d9
            mstore(0x80, 0xcaccb6d9)
            revert(0x9c, 0x04)
        }

        res := sub(left, right)
    }
}

function mulUnsignedInt(UnsignedInt left, UnsignedInt right) pure returns (UnsignedInt res) {
    assembly {
        switch or(iszero(left), iszero(right))
        case 0x01 { res := 0x00 }
        default { res := mul(left, right) }
    }
}

function divUnsignedInt(UnsignedInt left, UnsignedInt right) pure returns (UnsignedInt res) {
    assembly {
        if eq(right, 0x00) {
            /// @dev bytes4(keccak256("DivisionByZero()")) => 0x23d359a3
            mstore(0x80, 0x23d359a3)
            revert(0x9c, 0x04)
        }

        res := div(left, right)
    }
}

function modUnsignedInt(UnsignedInt left, UnsignedInt right) pure returns (UnsignedInt res) {
    assembly {
        if iszero(right) {
            /// @dev bytes4(keccak256("DivisionByZero()")) => 0x23d359a3
            mstore(0x80, 0x23d359a3)
            revert(0x9c, 0x04)
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
            for { let i := 0x1f } gt(i, 0x00) { i := sub(i, 1) } {
                let b := byte(i, u)

                /// NOTE: check existency of first nibble
                let x := and(b, 0x0f)
                if gt(x, 0x00) {
                    size := add(size, add(tmp, 0x01))
                    tmp := 0x00
                }
                if eq(x, 0x00) { tmp := add(tmp, 0x01) }

                /// NOTE: check existency of second nibble
                let y := and(b, 0xf0)
                if gt(y, 0x00) { size := add(size, 0x01) }
                if eq(y, 0x00) { tmp := add(tmp, 0x01) }
            }

            size := mul(size, 0x04)
        }
    }
}
