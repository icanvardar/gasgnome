// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { Contract, ContractLib, FunctionInput, FunctionSignature } from "../src/libraries/ContractLib.sol";
import { Test, console } from "forge-std/Test.sol";

contract TestContract {
    uint256 public x;
    uint256 public y;
    bytes32 public z;

    function a() public payable {
        x = x + 1;
    }

    function b(uint256 incCount) public payable {
        y += incCount;
    }

    function c() public payable returns (uint256 result_1, bytes32 result_2) {
        result_1 = 1024;
        result_2 = "i know";
    }

    function d(uint256 incCount, bytes32 text) public payable returns (uint256 result_1, bytes32 result_2) {
        result_1 = incCount;
        result_2 = text;
    }

    function i() public {
        z = "hey, there";
    }

    function j(uint256 num) public {
        x = num;
    }

    function k() public pure returns (bytes32 result) {
        result = "oui";
    }

    function l(uint256 num, bytes32 text) public returns (bool result, bytes32 ctx) {
        x = num;
        z = text;

        result = true;
        ctx = "this is result";
    }

    function o(bool change) public pure returns (string memory result_1, uint256[] memory result_2) {
        if (change == true) {
            uint256[] memory tmp = new uint256[](3);
            tmp[0] = 1;
            tmp[1] = 2;
            tmp[2] = 3;
            result_2 = tmp;
        } else {
            uint256[] memory tmp = new uint256[](3);
            tmp[0] = 11;
            tmp[1] = 22;
            tmp[2] = 33;
            result_2 = tmp;
        }
        result_1 = "hello there";
    }

    receive() external payable { }

    fallback() external payable { }
}

/// @dev This is a contract that has no receive function and it is for error reverts.
contract TestContract2 { }

contract ContractLibTest is Test {
    using ContractLib for address;

    TestContract internal testContract;
    TestContract2 internal testContract2;

    address internal caller = address(1);

    FunctionSignature internal functionASig = FunctionSignature.wrap(bytes4(keccak256("a()")));
    FunctionSignature internal functionBSig = FunctionSignature.wrap(bytes4(keccak256("b(uint256)")));
    FunctionSignature internal functionCSig = FunctionSignature.wrap(bytes4(keccak256("c()")));
    FunctionSignature internal functionDSig = FunctionSignature.wrap(bytes4(keccak256("d(uint256,bytes32)")));
    FunctionSignature internal functionISig = FunctionSignature.wrap(bytes4(keccak256("i()")));
    FunctionSignature internal functionJSig = FunctionSignature.wrap(bytes4(keccak256("j(uint256)")));
    FunctionSignature internal functionKSig = FunctionSignature.wrap(bytes4(keccak256("k()")));
    FunctionSignature internal functionLSig = FunctionSignature.wrap(bytes4(keccak256("l(uint256,bytes32)")));
    FunctionSignature internal functionOSig = FunctionSignature.wrap(bytes4(keccak256("o(bool)")));

    uint256 internal sentAmount = 10 ether;

    error UnableToCall();
    error NotContract();

    function setUp() public {
        testContract = new TestContract();
        testContract2 = new TestContract2();
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
        c.call(sentAmount, functionASig, false);
        c.call(sentAmount, functionASig, false);

        assertEq(sentAmount * 2, c.balance());
        assertEq(2, testContract.x());
    }

    function test_Call_SendEtherAndCallFunctionWithInput() public {
        Contract c = address(testContract).toContract();
        uint256 expected = 3;
        FunctionInput[] memory fi = new FunctionInput[](1);
        fi[0] = FunctionInput.wrap(bytes32(uint256(expected)));

        vm.startPrank(caller);
        c.call(sentAmount, functionBSig, fi, false);

        assertEq(sentAmount, c.balance());
        assertEq(expected, testContract.y());
    }

    function test_Call_SendEtherCallFunctionAndGetReturnValue() public {
        Contract c = address(testContract).toContract();

        vm.startPrank(caller);
        (uint256 result_1, bytes32 result_2) = abi.decode(c.call(sentAmount, functionCSig, true), (uint256, bytes32));
        uint256 expected_1 = 1024;
        bytes32 expected_2 = "i know";

        assertEq(sentAmount, c.balance());
        assertEq(expected_1, result_1);
        assertEq(expected_2, result_2);
    }

    function test_Call_SendEtherCallFunctionAndGetReturnValueWithInput() public {
        Contract c = address(testContract).toContract();
        FunctionInput[] memory fi = new FunctionInput[](2);
        fi[0] = FunctionInput.wrap(bytes32(uint256(1024)));
        fi[1] = FunctionInput.wrap(bytes32("hi there"));

        vm.startPrank(caller);
        (uint256 result_1, bytes32 result_2) =
            abi.decode(c.call(sentAmount, functionDSig, fi, true), (uint256, bytes32));
        uint256 expected_1 = 1024;
        bytes32 expected_2 = "hi there";

        assertEq(expected_1, result_1);
        assertEq(expected_2, result_2);
    }

    function test_Call_JustCall() public {
        Contract c = address(testContract).toContract();
        bytes32 expected = "hey, there";

        c.call(functionISig, false);
        assertEq(expected, testContract.z());
    }

    function test_Call_JustCallWithInput() public {
        Contract c = address(testContract).toContract();
        uint256 expected = 1881;
        FunctionInput[] memory fi = new FunctionInput[](1);
        fi[0] = FunctionInput.wrap(bytes32(uint256(1881)));

        c.call(functionJSig, fi, false);
        assertEq(expected, testContract.x());
    }

    function test_Call_CallAndGetReturnValue() public {
        Contract c = address(testContract).toContract();
        bytes32 expected = "oui";

        bytes32 result = abi.decode(c.call(functionKSig, true), (bytes32));

        assertEq(expected, result);
    }

    function test_Call_CallAndGetReturnValueWithInput() public {
        Contract c = address(testContract).toContract();
        bool expected_1 = true;
        bytes32 expected_2 = "this is result";
        FunctionInput[] memory fi = new FunctionInput[](2);
        fi[0] = FunctionInput.wrap(bytes32(uint256(1881)));
        fi[1] = FunctionInput.wrap(bytes32("hola"));

        (bool result_1, bytes32 result_2) = abi.decode(c.call(functionLSig, fi, true), (bool, bytes32));
        assertEq(expected_1, result_1);
        assertEq(expected_2, result_2);

        assertEq(1881, testContract.x());
        assertEq(bytes32("hola"), testContract.z());
    }

    function test_Staticcall_StaticcallAndGetReturnValue() public view {
        Contract c = address(testContract).toContract();

        bytes32 result = abi.decode(c.staticcall(functionKSig), (bytes32));
        assertEq(result, testContract.k());
    }

    function test_Staticcall_StaticcallAndGetReturnValueWithInput() public view {
        Contract c = address(testContract).toContract();
        FunctionInput[] memory fi = new FunctionInput[](1);
        fi[0] = FunctionInput.wrap(bytes32(uint256(1)));

        (string memory result_1, uint256[] memory result_2) =
            abi.decode(c.staticcall(functionOSig, fi), (string, uint256[]));

        assertEq("hello there", result_1);
        assertEq(1, result_2[0]);
        assertEq(2, result_2[1]);
        assertEq(3, result_2[2]);
    }

    function test_RevertWhen_NoReceiveFunctionFound_Call_SendEther() public {
        Contract c = address(testContract2).toContract();

        vm.expectRevert(UnableToCall.selector);
        c.call(sentAmount);
    }

    function test_RevertWhen_NoReceiveFunctionFound_Call_SendEtherAndCallFunction() public {
        Contract c = address(testContract2).toContract();

        vm.expectRevert();
        c.call(sentAmount, FunctionSignature(functionLSig), false);
    }

    function test_RevertWhen_NoReceiveFunctionFound_Call_SendEtherAndCallFunctionWithInput() public {
        Contract c = address(testContract2).toContract();
        FunctionInput[] memory fi = new FunctionInput[](1);
        fi[0] = FunctionInput.wrap(bytes32("hello"));

        vm.expectRevert();
        c.call(sentAmount, FunctionSignature(functionLSig), fi, false);
    }

    function test_RevertWhen_NoReceiveFunctionFound_Call_JustCall() public {
        Contract c = address(testContract2).toContract();

        vm.expectRevert();
        c.call(functionISig, false);
    }

    function test_RevertWhen_NoReceiveFunctionFound_Call_JustCallWithInput() public {
        Contract c = address(testContract2).toContract();
        FunctionInput[] memory fi = new FunctionInput[](1);
        fi[0] = FunctionInput.wrap(bytes32(uint256(1881)));

        vm.expectRevert();
        c.call(functionJSig, fi, false);
    }

    function test_RevertIf_MalformedFunctionSignature_Staticcall_StaticcallAndGetReturnValue() public {
        Contract c = address(testContract).toContract();

        vm.expectRevert();
        c.staticcall(functionOSig);
    }

    function test_RevertIf_MalformedFunctionSignature_Staticcall_StaticcallAndGetReturnValueWithInput() public {
        Contract c = address(testContract).toContract();
        FunctionInput[] memory fi = new FunctionInput[](1);
        fi[0] = FunctionInput.wrap(bytes32("wrong parameter"));

        vm.expectRevert();
        c.staticcall(functionOSig, fi);
    }

    function test_RevertWhen_AddressIsNotContract_ToContract() public {
        vm.expectRevert(NotContract.selector);
        address(address(1)).toContract();
    }
}
