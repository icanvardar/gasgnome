// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { StorageLib } from "../src/libraries/StorageLib.sol";
import { Slot, SlotLib } from "../src/types/Slot.sol";
import { Test, console } from "forge-std/Test.sol";

struct MockSlots {
    bytes32 longString;
    bytes32 shortString;
    bytes32 boolean;
    bytes32 bytes32Example;
    bytes32 int256Example;
    bytes32 uint256Example;
    bytes32 addr;
}

abstract contract MockVariables {
    string public longString = "abcabcabcabcabcabcabcabcabcabcabc";
    string public shortString = "abc";
    bool public boolean = true;
    bytes32 public bytes32Example = "abc";
    int256 public int256Example = -1;
    uint256 public uint256Example = 1;
    address public addr = address(1);

    function getMockSlots() public pure returns (MockSlots memory ms) {
        assembly {
            mstore(ms, longString.slot)
            mstore(add(ms, 0x20), shortString.slot)
            mstore(add(ms, 0x40), boolean.slot)
            mstore(add(ms, 0x60), bytes32Example.slot)
            mstore(add(ms, 0x80), int256Example.slot)
            mstore(add(ms, 0xa0), uint256Example.slot)
            mstore(add(ms, 0xc0), addr.slot)
        }
    }
}

contract SlotLibTest is MockVariables, Test {
    MockSlots internal ms;

    constructor() {
        ms = getMockSlots();
    }

    function test_AsAddress() public view {
        address result = StorageLib.getSlot(ms.addr).asAddress();
        address expected = addr;

        assertEq(result, expected);
    }

    function test_AsBoolean() public view {
        bool result = StorageLib.getSlot(ms.boolean).asBoolean();
        bool expected = boolean;

        assertEq(result, expected);
    }

    function test_AsBytes32() public view {
        bytes32 result = StorageLib.getSlot(ms.bytes32Example).asBytes32();
        bytes32 expected = bytes32Example;

        assertEq(result, expected);
    }

    function test_AsInt256() public view {
        int256 result = StorageLib.getSlot(ms.int256Example).asInt256();
        int256 expected = int256Example;

        assertEq(result, expected);
    }

    function test_AsUint256() public view {
        uint256 result = StorageLib.getSlot(ms.uint256Example).asUint256();
        uint256 expected = uint256Example;

        assertEq(result, expected);
    }

    function test_AsString_LessThen32Bytes() public view {
        string memory result = StorageLib.getSlot(ms.shortString).asString();
        string memory expected = shortString;

        assertEq(result, expected);
    }

    function test_AsString_BiggerThen31Bytes() public view {
        string memory result = StorageLib.getSlot(ms.longString).asString();
        string memory expected = longString;

        assertEq(result, expected);
    }

    function test_AsBytes_LessThen32Bytes() public view {
        bytes memory result = StorageLib.getSlot(ms.shortString).asBytes();
        bytes memory expected = bytes(shortString);

        assertEq(result, expected);
    }

    function test_AsBytes_BiggerThen31Bytes() public view {
        bytes memory result = StorageLib.getSlot(ms.longString).asBytes();
        bytes memory expected = bytes(longString);

        assertEq(result, expected);
    }
}
