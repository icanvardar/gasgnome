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
