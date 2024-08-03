// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { Pointer, PointerLib } from "../src/types/Pointer.sol";
import { Base_Test } from "./Base.t.sol";

contract PointerLibTest is Base_Test {
    error ImmutableVariable();

    function test_Load() public pure {
        bytes32 location = bytes32(abi.encode(0x80));
        Pointer ptr = Pointer.wrap(location);

        ptr.store(bytes32(uint256(1)));

        bytes32 result = PointerLib.load(ptr);
        bytes32 expected = bytes32(bytes32(uint256(1)));

        assertEq(vm.toString(expected), vm.toString(result));
    }

    function test_Next() public pure {
        bytes32 location = bytes32(abi.encode(0x80));
        Pointer ptr = Pointer.wrap(location);
        Pointer nextPtr = ptr.next();
        Pointer expected;

        assembly {
            expected := add(ptr, 0x20)
        }

        assertEq(Pointer.unwrap(expected), Pointer.unwrap(nextPtr));
    }

    function test_Store_OnlyData() public pure {
        bytes32 location = bytes32(abi.encode(0x80));
        Pointer ptr = Pointer.wrap(location);
        bytes32 expected = bytes32(uint256(1024));
        ptr.store(expected);
        bytes32 result = ptr.load();

        assertEq(expected, result);
    }

    function test_Store_WithImmutability() public pure {
        bytes32 location = bytes32(abi.encode(0x80));
        Pointer ptr = Pointer.wrap(location);
        bytes32 expected = bytes32(uint256(1024));
        ptr.store(expected, true);
        bytes32 result = ptr.load();

        assertEq(expected, result);
    }

    function test_Update() public pure {
        bytes32 data = "am i data?";
        bytes32 newData = "yes, you are";

        Pointer ptr;
        assembly {
            ptr := 0x100
            mstore(ptr, data)
        }

        ptr.update(newData);

        bytes32 updatedData = ptr.load();

        assertEq(updatedData, newData);
    }

    function test_MemoryStorageLocation() public pure {
        Pointer ptr;
        assembly {
            ptr := 0x100
        }

        Pointer result = ptr.memoryStorageLocation();
        Pointer expected;
        assembly {
            expected := sub(0x6fff, div(ptr, 0x20))
        }

        assertEq(Pointer.unwrap(expected), Pointer.unwrap(result));
    }

    function test_RevertWhen_VariableIsImmutable_Update() public {
        bytes32 location = bytes32(abi.encode(0x80));
        Pointer ptr = Pointer.wrap(location);
        bytes32 data = bytes32(uint256(1024));
        ptr.store(data, true);

        bytes32 newData = bytes32(uint256(2048));

        vm.expectRevert(ImmutableVariable.selector);
        ptr.update(newData);
    }
}
