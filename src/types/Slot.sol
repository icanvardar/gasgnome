// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

struct Slot {
    bytes32 value;
}

using SlotLibrary for Slot global;

library SlotLibrary {
    function asAddress(Slot storage s) internal view returns (address result) {
        assembly {
            result := sload(s.slot)
        }
    }

    function asBoolean(Slot storage s) internal view returns (bool result) {
        assembly {
            result := sload(s.slot)
        }
    }

    function asBytes32(Slot storage s) internal view returns (bytes32 result) {
        assembly {
            result := sload(s.slot)
        }
    }

    function asUint256(Slot storage s) internal view returns (uint256 result) {
        assembly {
            result := sload(s.slot)
        }
    }

    function asInt256(Slot storage s) internal view returns (int256 result) {
        assembly {
            result := sload(s.slot)
        }
    }
}
