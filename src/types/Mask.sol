// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

type Mask is bytes32;

using MaskLib for Mask global;

library MaskLib {
    function updateDataWith(Mask m, uint256 slot, bytes32 data) public {
        assembly {
            let tmp := sload(slot)
            tmp := and(tmp, m)
            tmp := or(tmp, data)
            sstore(slot, tmp)
        }
    }

    function updateDataWith(Mask m, uint256 slot, bytes32 data, uint256 leftShiftLength) public {
        assembly {
            let tmp := sload(slot)
            tmp := and(tmp, m)
            tmp := or(tmp, data)
            sstore(slot, shl(leftShiftLength, data))
        }
    }
}
