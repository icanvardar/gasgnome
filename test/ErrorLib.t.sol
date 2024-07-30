// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { ErrorArg, ErrorLib, ErrorSelector } from "../src/libraries/ErrorLib.sol";
import { Test, console } from "forge-std/Test.sol";

contract ErrorLibTest is Test {
    error Test_1();
    error Test_2(uint256, uint256, bytes32);
    error FunkyTown();

    function test_ToErrorArgs() public pure {
        bytes32[] memory args = new bytes32[](3);
        args[0] = bytes32(uint256(1));
        args[1] = bytes32(uint256(2));
        args[2] = bytes32(uint256(3));

        ErrorArg[] memory eas = ErrorLib.toErrorArgs(args);

        uint8 i;
        for (i; i < eas.length; i++) {
            assertEq(ErrorArg.unwrap(eas[i]), args[i]);
        }
    }

    function test_ToErrorSelector_WithoutArgs() public pure {
        bytes memory ctx = "Test_1()";
        ErrorSelector es = ErrorLib.toErrorSelector(ctx);

        bytes4 expected = Test_1.selector;
        assertEq(expected, ErrorSelector.unwrap(es));
    }

    function test_ToErrorSelector_WithArgs() public pure {
        bytes memory ctx = "Test_2(uint256,uint256,bytes32)";
        ErrorSelector es = ErrorLib.toErrorSelector(ctx);

        bytes4 expected = Test_2.selector;
        assertEq(expected, ErrorSelector.unwrap(es));
    }

    function test_RevertError_Anonymous() public {
        vm.expectRevert();
        ErrorLib.revertError();
    }

    function test_RevertError_WithoutArgs() public {
        bytes memory ctx = "FunkyTown()";
        ErrorSelector es = ErrorLib.toErrorSelector(ctx);

        vm.expectRevert(FunkyTown.selector);
        es.revertError();
    }

    function test_RevertError_WithArgs() public {
        bytes memory ctx = "Test_2(uint256,uint256,bytes32)";
        ErrorSelector es = ErrorLib.toErrorSelector(ctx);

        ErrorArg[] memory eas = new ErrorArg[](3);
        eas[0] = ErrorArg.wrap(bytes32(uint256(1)));
        eas[1] = ErrorArg.wrap(bytes32(uint256(2)));
        eas[2] = ErrorArg.wrap(bytes32("champion"));

        vm.expectRevert(abi.encodeWithSelector(Test_2.selector, 1, 2, bytes32("champion")));
        es.revertError(eas);
    }
}
