// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

type Mask is bytes32;

using BitmaskLib for Mask global;

library BitmaskLib {
    function generate(uint256 maskLength) public pure returns (Mask mask) {
        assembly {
            mask := not(sub(shl(maskLength, 1), 1))
        }
    }

    function generate(uint256 maskLength, uint256 leftShiftLength) public pure returns (Mask mask) {
        assembly {
            /// bytes4(keccak256("WrongParameters()"))
            if gt(maskLength, leftShiftLength) {
                mstore(0x80, 0xbd28cf5f)
                revert(0x9c, 0x04)
            }

            mask := not(shl(leftShiftLength, sub(shl(maskLength, 1), 1)))
        }
    }
}
