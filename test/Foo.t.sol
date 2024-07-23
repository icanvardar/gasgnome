// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.26;

import { Foo } from "../src/Foo.sol";
import { Test, console } from "forge-std/Test.sol";

contract FooTest is Test {
    Foo public foo;

    function setUp() public {
        foo = new Foo();
    }

    function test_Bar() public view {
        string memory result = foo.bar();
        string memory expected = "Hello, World!";
        assertEq(keccak256(abi.encodePacked(result)), keccak256(abi.encodePacked(expected)));
    }
}
