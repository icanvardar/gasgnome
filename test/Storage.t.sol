// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.26;

import { Storage } from "../src/Storage.sol";
import { Slot, SlotLib } from "../src/types/Slot.sol";
import { Test, console } from "forge-std/Test.sol";

contract StorageTest is Test {
    address public addressSlot = address(123);
    int256 public int256Slot = -123;
    uint256 public uint256Slot = 123;
    bytes32 public bytes32Slot = bytes32("i'm a slot");
    bytes public bytesSlot = "i'm a slot";
    string public stringSlot = "i'm a slot";

    function test_GetSlotAddress() public {
        Slot storage s = Storage.getSlot(addressSlot);

        storeData(s, 1);

        assertEq(s.asUint256(), 1);
    }

    function test_GetSlotInt256() public {
        Slot storage s = Storage.getSlot(int256Slot);

        storeData(s, 2);

        assertEq(s.asUint256(), 2);
    }

    function test_GetSlotUint256() public {
        Slot storage s = Storage.getSlot(uint256Slot);

        storeData(s, 3);

        assertEq(s.asUint256(), 3);
    }

    function test_GetSlotBytes32() public {
        Slot storage s = Storage.getSlot(bytes32Slot);

        storeData(s, 4);

        assertEq(s.asUint256(), 4);
    }

    function test_GetSlotBytes() public {
        Slot storage s = Storage.getSlot(bytesSlot);

        storeData(s, 5);

        assertEq(s.asUint256(), 5);
    }

    function test_GetSlotString() public {
        Slot storage s = Storage.getSlot(stringSlot);

        storeData(s, 6);

        assertEq(s.asUint256(), 6);
    }

    function storeData(Slot storage s, uint256 data) internal {
        assembly {
            sstore(s.slot, data)
        }
    }
}
