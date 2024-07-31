// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { Contract, ContractLib, FunctionInput, FunctionSignature } from "../src/libraries/ContractLib.sol";
import { Test, console } from "forge-std/Test.sol";

contract TestContract {
    uint256 public x;
    uint256 public y;
    bytes32 public z;

    event ReceivedData(bytes data);

    function a() public payable {
        x = x + 1;
    }

    function b(uint256 incCount) public payable {
        y += incCount;
    }

    function c() public {
        x = x + 1;
    }

    function d(uint256 incCount, bytes32 text) public {
        y += incCount;
        z = text;
    }

    receive() external payable { }

    fallback() external payable { }
}

contract ContractLibTest is Test {
    using ContractLib for address;

    TestContract internal testContract;
    address internal caller = address(1);

    FunctionSignature internal functionASig = FunctionSignature.wrap(bytes4(keccak256("a()")));
    FunctionSignature internal functionBSig = FunctionSignature.wrap(bytes4(keccak256("b(uint256)")));
    FunctionSignature internal functionCSig = FunctionSignature.wrap(bytes4(keccak256("c()")));
    FunctionSignature internal functionDSig = FunctionSignature.wrap(bytes4(keccak256("d(uint256,bytes32)")));

    uint256 internal sentAmount = 10 ether;

    function setUp() public {
        testContract = new TestContract();
        vm.deal(caller, 1_000_000 ether);
    }

    function test_Call_SendEther() public {
        Contract c = address(testContract).toContract();

        vm.prank(caller);
        c.call(sentAmount);

        assertEq(sentAmount, c.balance());
    }

    function test_Call_SendEtherAndCallFunction() public {
        Contract c = address(testContract).toContract();

        vm.startPrank(caller);
        c.call(sentAmount, functionASig);
        c.call(sentAmount, functionASig);

        assertEq(sentAmount * 2, c.balance());
        assertEq(2, testContract.x());
    }

    function test_Call_SendEtherAndCallFunctionWithInput() public {
        Contract c = address(testContract).toContract();
        uint256 expected = 3;
        FunctionInput[] memory fi = new FunctionInput[](1);
        fi[0] = FunctionInput.wrap(bytes32(uint256(expected)));

        vm.startPrank(caller);
        c.call(sentAmount, functionBSig, fi);

        assertEq(sentAmount, c.balance());
        assertEq(expected, testContract.y());
    }

    function test_Call_SendEtherCallFunctionAndGetReturnValue() public { }

    function test_Call_SendEtherCallFunctionAndGetReturnValueWithInput() public { }

    function test_Call_JustCall() public { }

    function test_Call_JustCallWithInput() public { }

    function test_Call_CallAndGetReturnValue() public { }

    function test_Call_CallAndGetReturnValueWithInput() public { }

    function test_RevertWhen_NoReceiveFunctionFound_Call_SendEther() public { }

    function test_RevertWhen_NoReceiveFunctionFound_Call_SendEtherAndCallFunction() public { }

    function test_RevertWhen_NoReceiveFunctionFound_Call_SendEtherAndCallFunctionWithInput() public { }

    function test_RevertWhen_NoReceiveFunctionFound_Call_SendEtherCallFunctionAndGetReturnValue() public { }

    function test_RevertWhen_NoReceiveFunctionFound_Call_SendEtherCallFunctionAndGetReturnValueWithInput() public { }

    function test_RevertWhen_NoReceiveFunctionFound_Call_JustCall() public { }

    function test_RevertWhen_NoReceiveFunctionFound_Call_JustCallWithInput() public { }

    function test_RevertWhen_NoReceiveFunctionFound_Call_CallAndGetReturnValue() public { }

    function test_RevertWhen_NoReceiveFunctionFound_Call_CallAndGetReturnValueWithInput() public { }
}
