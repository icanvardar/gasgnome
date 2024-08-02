// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { Contract, ContractLib, FunctionInput, FunctionSignature } from "../../src/libraries/ContractLib.sol";

contract ContractLibProxy {
    bytes32 internal numberOneSlot = bytes32(keccak256("number.1"));
    bytes32 internal numberTwoSlot = bytes32(keccak256("number.2"));
    bytes32 internal numberThreeSlot = bytes32(keccak256("number.3"));
    bytes32 internal numberFourSlot = bytes32(keccak256("number.4"));
    bytes32 internal implementationSlot = bytes32(keccak256("implementation"));

    constructor(address _implementation) {
        assembly {
            sstore(implementationSlot.slot, _implementation)
        }
    }

    function getImplementationContract() public view returns (Contract result) {
        assembly {
            result := sload(implementationSlot.slot)
        }
    }

    function getNumberOne() public view returns (uint256 result) {
        assembly {
            result := sload(numberOneSlot.slot)
        }
    }

    function getNumberTwo() public view returns (uint256 result) {
        assembly {
            result := sload(numberTwoSlot.slot)
        }
    }

    function getNumberThree() public view returns (uint256 result) {
        assembly {
            result := sload(numberThreeSlot.slot)
        }
    }

    function getNumberFour() public view returns (uint256 result) {
        assembly {
            result := sload(numberFourSlot.slot)
        }
    }

    function delegatecallWithoutInputAndWithoutReturnValue() public {
        Contract c = getImplementationContract();
        FunctionSignature fs = FunctionSignature.wrap(bytes4(keccak256("setNumberOne()")));

        c.delegatecall(fs, false);
    }

    function delegatecallWithoutInputAndWithReturnValue() public returns (bytes memory result) {
        Contract c = getImplementationContract();
        FunctionSignature fs = FunctionSignature.wrap(bytes4(keccak256("setNumberTwo()")));

        result = c.delegatecall(fs, true);
    }

    function delegatecallWithInputAndWithoutReturnValue() public {
        Contract c = getImplementationContract();
        FunctionSignature fs = FunctionSignature.wrap(bytes4(keccak256("setNumberThree(uint256)")));
        FunctionInput[] memory fi = new FunctionInput[](1);
        fi[0] = FunctionInput.wrap(bytes32(uint256(4096)));

        c.delegatecall(fs, fi, false);
    }

    function delegatecallWithInputAndWithReturnValue() public returns (bytes memory result) {
        Contract c = getImplementationContract();
        FunctionSignature fs = FunctionSignature.wrap(bytes4(keccak256("setNumberFour(uint256)")));
        FunctionInput[] memory fi = new FunctionInput[](1);
        fi[0] = FunctionInput.wrap(bytes32(uint256(8192)));

        result = c.delegatecall(fs, fi, true);
    }

    function delegatecallWrongFunctionSignatureWithoutInput() public {
        Contract c = getImplementationContract();
        FunctionSignature fs = FunctionSignature.wrap(bytes4(keccak256("setNumberOneA()")));

        c.delegatecall(fs, false);
    }

    function delegatecallWrongFunctionSignatureWithInput() public {
        Contract c = getImplementationContract();
        FunctionSignature fs = FunctionSignature.wrap(bytes4(keccak256("setNumberThreeA(uint256)")));
        FunctionInput[] memory fi = new FunctionInput[](1);
        fi[0] = FunctionInput.wrap(bytes32(uint256(4096)));

        c.delegatecall(fs, fi, false);
    }
}
