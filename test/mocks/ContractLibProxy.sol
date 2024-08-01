// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { Contract, ContractLib, FunctionInput, FunctionSignature } from "../../src/libraries/ContractLib.sol";

contract ContractLibProxy {
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

    function delegatecallWithoutInputAndWithoutReturnValue() public view {
        Contract c = getImplementationContract();
        FunctionSignature fs = FunctionSignature.wrap(bytes4(keccak256("setNumberOne()")));

        c.delegatecall(fs, false);
    }

    function delegatecallWithoutInputAndWithReturnValue() public view returns (bytes memory result) {
        Contract c = getImplementationContract();
        FunctionSignature fs = FunctionSignature.wrap(bytes4(keccak256("setNumberTwo()")));

        result = c.delegatecall(fs, true);
    }

    function delegatecallWithInputAndWithoutReturnValue() public view {
        Contract c = getImplementationContract();
        FunctionSignature fs = FunctionSignature.wrap(bytes4(keccak256("setNumberThree(uint256)")));
        FunctionInput[] memory fi = new FunctionInput[](1);
        fi[0] = FunctionInput.wrap(bytes32(uint256(4096)));

        c.delegatecall(fs, fi, false);
    }

    function delegatecallWithInputAndWithReturnValue() public view returns (bytes memory result) {
        Contract c = getImplementationContract();
        FunctionSignature fs = FunctionSignature.wrap(bytes4(keccak256("setNumberFour(uint256)")));
        FunctionInput[] memory fi = new FunctionInput[](1);
        fi[0] = FunctionInput.wrap(bytes32(uint256(8192)));

        result = c.delegatecall(fs, fi, true);
    }
}
