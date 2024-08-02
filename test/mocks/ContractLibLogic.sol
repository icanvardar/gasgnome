// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

contract ContractLibLogic {
    bytes32 internal numberOneSlot = bytes32(keccak256("number.1"));
    bytes32 internal numberTwoSlot = bytes32(keccak256("number.2"));
    bytes32 internal numberThreeSlot = bytes32(keccak256("number.3"));
    bytes32 internal numberFourSlot = bytes32(keccak256("number.4"));

    function setNumberOne() public {
        assembly {
            sstore(numberOneSlot.slot, 1024)
        }
    }

    function setNumberTwo() public returns (uint256 newValue) {
        assembly {
            newValue := 2048
            sstore(numberTwoSlot.slot, newValue)
        }
    }

    function setNumberThree(uint256 num) public {
        assembly {
            sstore(numberThreeSlot.slot, num)
        }
    }

    function setNumberFour(uint256 num) public returns (uint256 newValue) {
        assembly {
            newValue := num
            sstore(numberFourSlot.slot, newValue)
        }
    }
}
