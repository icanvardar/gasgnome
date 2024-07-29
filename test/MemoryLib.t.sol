// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { MemoryLib } from "../src/libraries/MemoryLib.sol";
import { Test, console } from "forge-std/Test.sol";

contract MemoryLibTest is Test {
    function test_FreeMemory() public pure {
        bytes32 result = MemoryLib.freeMemory();
        bytes32 expected = bytes32(abi.encode(0x80));

        assertEq(vm.toString(expected), vm.toString(result));
    }

    function test_NextFreeMemory() public pure {
        bytes32 result = MemoryLib.nextFreeMemory();
        bytes32 expected = bytes32(abi.encode(0x80 + 0x20));

        assertEq(vm.toString(expected), vm.toString(result));
    }

    function test_Store_OnlyData() public pure {
        bytes32 data = "i am data";
        bytes32 nextPtr = MemoryLib.store(data);

        bytes32 expectedData;
        bytes32 expectedNextPtr;
        assembly {
            expectedData := mload(0x80)
            expectedNextPtr := 0xa0
        }

        assertEq(expectedData, data);
        assertEq(expectedNextPtr, nextPtr);
    }

    function test_Store_WithImmutability() public pure {
        bytes32 data = "i am data, too";
        bytes32 nextPtr = MemoryLib.store(data, true);

        bytes32 expectedData;
        bytes32 expectedNextPtr;
        assembly {
            expectedData := mload(0x80)
            expectedNextPtr := 0xa0
        }

        assertEq(expectedData, data);
        assertEq(expectedNextPtr, nextPtr);
    }

    function test_Update() public { }

    function test_MemoryStorageLocation() public { }

    function test_RevertWhen_VariableIsImmutable_Update() public { }
}
