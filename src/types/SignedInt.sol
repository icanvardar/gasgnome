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

function addSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt result) {
    assembly {
        result := add(left, right)
    }
}

function subSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt result) {
    assembly {
        result := sub(left, right)
    }
}

function mulSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt result) {
    assembly {
        switch or(iszero(left), iszero(right))
        case 0x01 { result := 0x00 }
        default { result := mul(left, right) }
    }
}

function divSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt result) {
    assembly {
        if eq(right, 0x00) {
            /// @dev bytes4(keccak256("DivisionByZero()")) => 0x23d359a3
            mstore(0x80, 0x23d359a3)
            revert(0x9c, 0x04)
        }

        let l := slt(left, 0x00)
        let r := slt(right, 0x00)
        let sign := xor(l, r)

        if l { left := sub(0x00, left) }
        if r { right := sub(0x00, right) }

        result := div(left, right)

        if sign { result := sub(0x00, result) }
    }
}

function modSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt result) {
    assembly {
        if eq(right, 0x00) {
            /// @dev bytes4(keccak256("DivisionByZero()")) => 0x23d359a3
            mstore(0x80, 0x23d359a3)
            revert(0x9c, 0x04)
        }

        let l := slt(left, 0x00)
        if l { left := sub(0x00, left) }
        if slt(right, 0x00) { right := sub(0x00, right) }

        result := mod(left, right)

        if l { result := sub(0x00, result) }
    }
}

function expSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt result) {
    assembly {
        if slt(right, 0x00) {
            /// bytes4(keccak256("NegativeExponent()"))
            mstore(0x80, 0xe782e44b)
            revert(0x9c, 0x04)
        }

        result := exp(left, right)

        if slt(left, 0x00) { result := sub(0x00, result) }
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
            let isNegative := sgt(0x00, s)
            let absValue := s
            if isNegative { absValue := sub(0x00, s) }

            for { let i := 0x1f } gt(i, 0x00) { i := sub(i, 1) } {
                let b := byte(i, absValue)

                /// Check existency of first nibble
                let x := and(b, 0x0f)
                if gt(x, 0x00) {
                    size := add(size, add(tmp, 0x01))
                    tmp := 0x00
                }
                if eq(x, 0x00) { tmp := add(tmp, 0x01) }

                /// Check existency of second nibble
                let y := and(b, 0xf0)
                if gt(y, 0x00) { size := add(size, 0x01) }
                if eq(y, 0x00) { tmp := add(tmp, 0x01) }
            }

            size := mul(size, 0x04)
        }
    }
}
