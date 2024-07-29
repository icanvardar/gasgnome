// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { MemoryLib } from "../src/libraries/MemoryLib.sol";
import { Test, console } from "forge-std/Test.sol";

contract MemoryLibTest is Test {
    error ImmutableVariable();

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

    function test_Update() public pure {
        bytes32 data = "am i data?";
        bytes32 newData = "yes, you are";

        bytes32 dataLocation;
        assembly {
            dataLocation := 0x100
            mstore(dataLocation, data)
        }

        MemoryLib.update(dataLocation, newData);

        bytes32 updatedData;
        assembly {
            updatedData := mload(dataLocation)
        }

        assertEq(updatedData, newData);
    }

    function test_MemoryStorageLocation() public pure {
        bytes32 pseudoPtr;
        assembly {
            pseudoPtr := 0x100
        }

        bytes32 result = MemoryLib.memoryStorageLocation(pseudoPtr);
        bytes32 expected;
        assembly {
            expected := sub(0x6ffffff, div(pseudoPtr, 0x20))
        }

        assertEq(result, expected);
    }

    function test_RevertWhen_VariableIsImmutable_Update() public {
        bytes32 data = "hey";

        bytes32 nextPtr = MemoryLib.store(data, true);
        bytes32 location;
        bytes32 am;
        assembly {
            location := sub(nextPtr, 0x20)
            am := mload(location)
        }

        vm.expectRevert(ImmutableVariable.selector);
        MemoryLib.update(location, "hello");

        console.log(vm.toString(am));
    }
}
