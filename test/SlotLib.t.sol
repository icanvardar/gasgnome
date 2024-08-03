// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { StorageLib } from "../src/libraries/StorageLib.sol";
import { Slot, SlotLib } from "../src/types/Slot.sol";

import { Base_Test } from "./Base.t.sol";

contract SlotLibTest is Base_Test {
    function test_AsAddress() public view {
        address result = StorageLib.getSlot(slots.addr).asAddress();
        address expected = addr;

        assertEq(result, expected);
    }

    function test_AsBoolean() public view {
        bool result = StorageLib.getSlot(slots.boolean).asBoolean();
        bool expected = boolean;

        assertEq(result, expected);
    }

    function test_AsBytes32() public view {
        bytes32 result = StorageLib.getSlot(slots.bytes32Example).asBytes32();
        bytes32 expected = bytes32Example;

        assertEq(result, expected);
    }

    function test_AsInt256() public view {
        int256 result = StorageLib.getSlot(slots.int256Example).asInt256();
        int256 expected = int256Example;

        assertEq(result, expected);
    }

    function test_AsUint256() public view {
        uint256 result = StorageLib.getSlot(slots.uint256Example).asUint256();
        uint256 expected = uint256Example;

        assertEq(result, expected);
    }

    function test_AsString_LessThen32Bytes() public view {
        string memory result = StorageLib.getSlot(slots.shortString).asString();
        string memory expected = shortString;

        assertEq(result, expected);
    }

    function test_AsString_BiggerThen31Bytes() public view {
        string memory result = StorageLib.getSlot(slots.longString).asString();
        string memory expected = longString;

        assertEq(result, expected);
    }

    function test_AsBytes_LessThen32Bytes() public view {
        bytes memory result = StorageLib.getSlot(slots.shortString).asBytes();
        bytes memory expected = bytes(shortString);

        assertEq(result, expected);
    }

    function test_AsBytes_BiggerThen31Bytes() public view {
        bytes memory result = StorageLib.getSlot(slots.longString).asBytes();
        bytes memory expected = bytes(longString);

        assertEq(result, expected);
    }

    function test_AsAddressSlot() public pure {
        bytes32 addressSlot = bytes32("addressSlot");

        SlotLib.AddressSlot result = SlotLib.asAddressSlot(addressSlot);

        assertEq(SlotLib.AddressSlot.unwrap(result), addressSlot);
    }

    function test_Tstore_AddressSlot() public {
        bytes32 addressSlot = bytes32("addressSlot");
        address expected = address(1);

        SlotLib.tstore(SlotLib.AddressSlot.wrap(addressSlot), expected);

        address result;
        assembly {
            result := tload(addressSlot)
        }

        assertEq(expected, result);
    }

    function test_TLoad_AddressSlot() public {
        bytes32 addressSlot = bytes32("addressSlot");
        address expected = address(1);

        SlotLib.AddressSlot slot = SlotLib.asAddressSlot(addressSlot);

        SlotLib.tstore(slot, expected);

        address result = SlotLib.tload(slot);

        assertEq(expected, result);
    }

    function test_AsBooleanSlot() public pure {
        bytes32 booleanSlot = bytes32("booleanSlot");

        SlotLib.BooleanSlot result = SlotLib.asBooleanSlot(booleanSlot);

        assertEq(SlotLib.BooleanSlot.unwrap(result), booleanSlot);
    }

    function test_Tstore_BooleanSlot() public {
        bytes32 booleanSlot = bytes32("booleanSlot");
        bool expected = true;

        SlotLib.tstore(SlotLib.BooleanSlot.wrap(booleanSlot), expected);

        bool result;
        assembly {
            result := tload(booleanSlot)
        }

        assertEq(expected, result);
    }

    function test_TLoad_BooleanSlot() public {
        bytes32 booleanSlot = bytes32("booleanSlot");
        bool expected = true;

        SlotLib.BooleanSlot slot = SlotLib.asBooleanSlot(booleanSlot);

        SlotLib.tstore(slot, expected);

        bool result = SlotLib.tload(slot);

        assertEq(expected, result);
    }

    function test_AsBytes32Slot() public pure {
        bytes32 bytes32Slot = bytes32("bytes32Slot");

        SlotLib.Bytes32Slot result = SlotLib.asBytes32Slot(bytes32Slot);

        assertEq(SlotLib.Bytes32Slot.unwrap(result), bytes32Slot);
    }

    function test_Tstore_Bytes32Slot() public {
        bytes32 bytes32Slot = bytes32("bytes32Slot");
        bytes32 expected = "test";

        SlotLib.tstore(SlotLib.Bytes32Slot.wrap(bytes32Slot), expected);

        bytes32 result;
        assembly {
            result := tload(bytes32Slot)
        }

        assertEq(expected, result);
    }

    function test_TLoad_Bytes32Slot() public {
        bytes32 bytes32Slot = bytes32("bytes32Slot");
        bytes32 expected = "test";

        SlotLib.Bytes32Slot slot = SlotLib.asBytes32Slot(bytes32Slot);

        SlotLib.tstore(slot, expected);

        bytes32 result = SlotLib.tload(slot);

        assertEq(expected, result);
    }

    function test_AsInt256Slot() public pure {
        bytes32 int256Slot = bytes32("int256Slot");

        SlotLib.Int256Slot result = SlotLib.asInt256Slot(int256Slot);

        assertEq(SlotLib.Int256Slot.unwrap(result), int256Slot);
    }

    function test_Tstore_Int256Slot() public {
        bytes32 int256Slot = bytes32("int256Slot");
        int256 expected = -32;

        SlotLib.tstore(SlotLib.Int256Slot.wrap(int256Slot), expected);

        int256 result;
        assembly {
            result := tload(int256Slot)
        }

        assertEq(expected, result);
    }

    function test_TLoad_Int256Slot() public {
        bytes32 int256Slot = bytes32("int256Slot");
        int256 expected = -32;

        SlotLib.Int256Slot slot = SlotLib.asInt256Slot(int256Slot);

        SlotLib.tstore(slot, expected);

        int256 result = SlotLib.tload(slot);

        assertEq(expected, result);
    }

    function test_AsUint256Slot() public pure {
        bytes32 uint256Slot = bytes32("uint256Slot");

        SlotLib.Uint256Slot result = SlotLib.asUint256Slot(uint256Slot);

        assertEq(SlotLib.Uint256Slot.unwrap(result), uint256Slot);
    }

    function test_Tstore_Uint256Slot() public {
        bytes32 uint256Slot = bytes32("uint256Slot");
        uint256 expected = 32;

        SlotLib.tstore(SlotLib.Uint256Slot.wrap(uint256Slot), expected);

        uint256 result;
        assembly {
            result := tload(uint256Slot)
        }

        assertEq(expected, result);
    }

    function test_TLoad_Uint256Slot() public {
        bytes32 uint256Slot = bytes32("uint256Slot");
        uint256 expected = 32;

        SlotLib.Uint256Slot slot = SlotLib.asUint256Slot(uint256Slot);

        SlotLib.tstore(slot, expected);

        uint256 result = SlotLib.tload(slot);

        assertEq(expected, result);
    }
}
