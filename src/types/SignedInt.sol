// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { ArithmeticLib } from "../libraries/ArithmeticLib.sol";

type SignedInt is bytes32;

using {
    addSignedInt as +,
    subSignedInt as -,
    mulSignedInt as *,
    divSignedInt as /,
    modSignedInt as %,
    expSignedInt as ^
} for SignedInt global;

function addSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt res) {
    assembly {
        res := add(left, right)
    }
}

function subSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt res) {
    assembly {
        res := sub(left, right)
    }
}

function mulSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt res) {
    assembly {
        switch or(iszero(left), iszero(right))
        case 1 { res := 0 }
        default { res := mul(left, right) }
    }
}

function divSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt res) {
    assembly {
        if eq(right, 0) {
            /// @dev bytes4(keccak256("DivisionByZero()")) => 0x23d359a3
            mstore(0x80, 0x23d359a3)
            revert(0x9c, 0x04)
        }

        let leftNeg := slt(left, 0)
        let rightNeg := slt(right, 0)
        let sign := xor(leftNeg, rightNeg)

        if leftNeg { left := sub(0, left) }
        if rightNeg { right := sub(0, right) }

        let absRes := div(left, right)
        res := absRes
        if sign { res := sub(0, absRes) }
    }
}

function modSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt res) {
    assembly {
        if iszero(right) {
            /// TODO: add custom error here - modulo by zero check
            revert(0x00, 0x00)
        }

        res := mod(left, right)
    }
}

function expSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt res) {
    assembly {
        res := exp(left, right)
    }
}

using SignedIntLib for SignedInt global;

library SignedIntLib {
    function convertWithSize(SignedInt u, uint16 desiredBits) public pure returns (int256 to) {
        bytes32 result = ArithmeticLib.convertWithSize(SignedInt.unwrap(u), desiredBits, sizeInBits(u));

        assembly {
            to := result
        }
    }

    function sizeInBits(SignedInt s) public pure returns (uint16 size) {
        assembly {
            let tmp
            let isNegative := sgt(0, s)
            let absValue := s
            if isNegative { absValue := sub(0, s) }

            for { let i := 0x1f } gt(i, 0x0) { i := sub(i, 1) } {
                let b := byte(i, absValue)

                /// Check existency of first nibble
                let x := and(b, 0x0f)
                if gt(x, 0) {
                    size := add(size, add(tmp, 0x1))
                    tmp := 0x0
                }
                if eq(x, 0) { tmp := add(tmp, 0x1) }

                /// Check existency of second nibble
                let y := and(b, 0xf0)
                if gt(y, 0) { size := add(size, 0x1) }
                if eq(y, 0) { tmp := add(tmp, 0x1) }
            }

            size := mul(size, 0x4)
        }
    }
}
