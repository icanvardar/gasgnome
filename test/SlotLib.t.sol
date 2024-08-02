// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { StorageLib } from "../src/libraries/StorageLib.sol";
import { Slot, SlotLib } from "../src/types/Slot.sol";

import { Variables } from "../test/mocks/Variables.sol";
import { Test, console } from "forge-std/Test.sol";

contract SlotLibTest is Variables, Test {
    Variables.Slots internal s;

    function setUp() public {
        s = getSlots();
    }

    function test_AsAddress() public view {
        address result = StorageLib.getSlot(s.addr).asAddress();
        address expected = addr;

        assertEq(result, expected);
    }

    function test_AsBoolean() public view {
        bool result = StorageLib.getSlot(s.boolean).asBoolean();
        bool expected = boolean;

        assertEq(result, expected);
    }

    function test_AsBytes32() public view {
        bytes32 result = StorageLib.getSlot(s.bytes32Example).asBytes32();
        bytes32 expected = bytes32Example;

        assertEq(result, expected);
    }

    function test_AsInt256() public view {
        int256 result = StorageLib.getSlot(s.int256Example).asInt256();
        int256 expected = int256Example;

        assertEq(result, expected);
    }

    function test_AsUint256() public view {
        uint256 result = StorageLib.getSlot(s.uint256Example).asUint256();
        uint256 expected = uint256Example;

        assertEq(result, expected);
    }

    function test_AsString_LessThen32Bytes() public view {
        string memory result = StorageLib.getSlot(s.shortString).asString();
        string memory expected = shortString;

        assertEq(result, expected);
    }

    function test_AsString_BiggerThen31Bytes() public view {
        string memory result = StorageLib.getSlot(s.longString).asString();
        string memory expected = longString;

        assertEq(result, expected);
    }

    function test_AsBytes_LessThen32Bytes() public view {
        bytes memory result = StorageLib.getSlot(s.shortString).asBytes();
        bytes memory expected = bytes(shortString);

        assertEq(result, expected);
    }

    function test_AsBytes_BiggerThen31Bytes() public view {
        bytes memory result = StorageLib.getSlot(s.longString).asBytes();
        bytes memory expected = bytes(longString);

        assertEq(result, expected);
    }
}
