// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.26;

import { Storage } from "../src/Storage.sol";
import { Slot, SlotLib } from "../src/types/Slot.sol";
import { Test, console } from "forge-std/Test.sol";

struct MockSlots {
    bytes32 boolean;
    bytes32 bytes32Example;
    bytes32 int256Example;
    bytes32 uint256Example;
    bytes32 shortString;
    bytes32 longString;
    bytes32 addr;
}

abstract contract StorageVariables {
    bool public boolean = true;
    bytes32 public bytes32Example = "abc";
    int256 public int256Example = -1;
    uint256 public uint256Example = 1;
    string public shortString = "abc";
    string public longString = "abcabcabcabcabcabcabcabcabcabcabc";
    address public addr = address(1);

    function getMockSlots() public pure returns (MockSlots memory ms) {
        assembly {
            mstore(ms, boolean.slot)
            mstore(add(ms, 0x20), bytes32Example.slot)
            mstore(add(ms, 0x40), int256Example.slot)
            mstore(add(ms, 0x60), uint256Example.slot)
            mstore(add(ms, 0x80), shortString.slot)
            mstore(add(ms, 0xa0), longString.slot)
            mstore(add(ms, 0xc0), addr.slot)
        }
    }
}

contract SlotLibTest is StorageVariables, Test {
    MockSlots internal ms;

    constructor() {
        ms = getMockSlots();
    }

    function test_AsAddress() public view {
        address result = Storage.getSlot(ms.addr).asAddress();
        address expected = addr;

        assertEq(result, expected);
    }

    function test_AsBoolean() public view {
        bool result = Storage.getSlot(ms.boolean).asBoolean();
        bool expected = boolean;

        assertEq(result, expected);
    }

    function test_AsBytes32() public view {
        bytes32 result = Storage.getSlot(ms.bytes32Example).asBytes32();
        bytes32 expected = bytes32Example;

        assertEq(result, expected);
    }

    function test_AsInt256() public view {
        int256 result = Storage.getSlot(ms.int256Example).asInt256();
        int256 expected = int256Example;

        assertEq(result, expected);
    }

    function test_AsUint256() public view {
        uint256 result = Storage.getSlot(ms.uint256Example).asUint256();
        uint256 expected = uint256Example;

        assertEq(result, expected);
    }

    function test_AsString_LessThen32Bytes() public view {
        string memory result = Storage.getSlot(ms.shortString).asString();
        string memory expected = shortString;

        assertEq(result, expected);
    }

    // function test_AsString_BiggerThen31Bytes() public view {
    //     string memory result = Storage.getSlot(ms.longString).asString();
    //     string memory expected = longString;

    //     assertEq(result, expected);
    // }
}
