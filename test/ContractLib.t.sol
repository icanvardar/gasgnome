// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { Contract, ContractLib, FunctionInput, FunctionSignature } from "../src/libraries/ContractLib.sol";

import { ContractLibLogic } from "./mocks/ContractLibLogic.sol";
import { ContractLibProxy } from "./mocks/ContractLibProxy.sol";
import { ExternalFunctions } from "./mocks/ExternalFunctions.sol";

import { Test, console } from "forge-std/Test.sol";

contract ContractLibTest is Test {
    using ContractLib for address;

    ExternalFunctions internal testContract;
    ContractLibProxy internal contractLibProxy;
    ContractLibLogic internal contractLibLogic;
    address internal testContract2 = vm.randomAddress();

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
        testContract = new ExternalFunctions();
        contractLibLogic = new ContractLibLogic();
        contractLibProxy = new ContractLibProxy(address(contractLibLogic));
        vm.deal(caller, 1_000_000 ether);
        vm.etch(testContract2, hex"60806040525f80fdfea164736f6c634300081a000a");
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

    function test_Delegatecall_WithoutInputAndWithoutReturnValue() public {
        contractLibProxy.delegatecallWithoutInputAndWithoutReturnValue();

        uint256 expected = 1024;
        uint256 numberOne = contractLibProxy.getNumberOne();

        assertEq(expected, numberOne);
    }

    function test_Delegatecall_WithoutInputAndWithReturnValue() public {
        contractLibProxy.delegatecallWithoutInputAndWithReturnValue();

        uint256 expected = 2048;
        uint256 numberTwo = contractLibProxy.getNumberTwo();

        assertEq(expected, numberTwo);
    }

    function test_Delegatecall_WithInputAndWithoutReturnValue() public {
        contractLibProxy.delegatecallWithInputAndWithoutReturnValue();

        uint256 expected = 4096;
        uint256 numberThree = contractLibProxy.getNumberThree();

        assertEq(expected, numberThree);
    }

    function test_Delegatecall_WithInputAndWithReturnValue() public {
        contractLibProxy.delegatecallWithInputAndWithReturnValue();

        uint256 expected = 8192;
        uint256 numberFour = contractLibProxy.getNumberFour();

        assertEq(expected, numberFour);
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
