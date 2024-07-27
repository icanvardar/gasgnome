// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

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
        case 0 { res := 0 }
        case 1 { res := mul(left, right) }
    }
}

function divSignedInt(SignedInt left, SignedInt right) pure returns (SignedInt res) {
    assembly {
        res := div(left, right)
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
