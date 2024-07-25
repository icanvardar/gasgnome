// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { Slot } from "../types/Slot.sol";

library StorageLib {
    function getSlot(address slot) public pure returns (Slot storage s) {
        assembly {
            s.slot := slot
        }
    }

    function getSlot(int256 slot) public pure returns (Slot storage s) {
        assembly {
            s.slot := slot
        }
    }

    function getSlot(uint256 slot) public pure returns (Slot storage s) {
        assembly {
            s.slot := slot
        }
    }

    function getSlot(bytes32 slot) public pure returns (Slot storage s) {
        assembly {
            s.slot := slot
        }
    }

    function getSlot(bytes storage ptr) public pure returns (Slot storage s) {
        assembly {
            s.slot := ptr.slot
        }
    }

    function getSlot(string storage ptr) public pure returns (Slot storage s) {
        assembly {
            s.slot := ptr.slot
        }
    }
}
