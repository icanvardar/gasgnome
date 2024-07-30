// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

type ErrorSelector is bytes4;

type ErrorArg is bytes32;

using ErrorLib for ErrorSelector global;

library ErrorLib {
    function toErrorArgs(bytes32[] memory args) public pure returns (ErrorArg[] memory eas) {
        assembly {
            let len := mload(args)
            mstore(eas, len)

            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                let multiplier := mul(add(i, 1), 0x20)
                let arg := mload(add(args, multiplier))
                mstore(add(eas, multiplier), arg)
            }
        }
    }

    function toErrorSelector(bytes memory ctx) public pure returns (ErrorSelector es) {
        assembly {
            let dataPtr := add(ctx, 0x20)
            let dataLength := mload(ctx)
            let hash := keccak256(dataPtr, dataLength)
            es := shl(224, shr(224, hash))
        }
    }

    function revertError() public pure {
        assembly {
            revert(0x00, 0x00)
        }
    }

    function revertError(ErrorSelector es) internal pure {
        assembly {
            let freePtr := mload(0x40)
            mstore(freePtr, shr(224, es))
            revert(add(0x1c, freePtr), 0x04)
        }
    }

    /// NOTE: This function does not support dynamic types, currently.
    function revertError(ErrorSelector es, ErrorArg[] memory eas) public pure {
        assembly {
            let freePtr := mload(0x40)
            let selectorPtr := freePtr

            /// NOTE: Even the error selector's underlying type is bytes4,
            /// in inline assembly it is converted to bytes32 and right padded,
            /// so that right shift is needed to copy the selector!
            mstore(selectorPtr, shr(224, es))
            freePtr := add(freePtr, 0x20)

            let len := mload(eas)
            let initPtr := add(eas, 0x20)

            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                let arg := mload(add(initPtr, mul(i, 0x20)))
                mstore(add(freePtr, mul(i, 0x20)), arg)
            }

            let total := add(0x04, mul(len, 0x20))
            revert(add(0x1c, selectorPtr), total)
        }
    }
}
