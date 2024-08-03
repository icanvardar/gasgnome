// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { ContractLibLogic } from "./mocks/ContractLibLogic.sol";
import { ContractLibProxy } from "./mocks/ContractLibProxy.sol";
import { ExternalFunctions } from "./mocks/ExternalFunctions.sol";
import { Variables } from "./mocks/Variables.sol";
import { Test } from "forge-std/Test.sol";

struct Accounts {
    address payable caller;
}

abstract contract Base_Test is Variables, Test {
    Accounts internal accounts;
    Variables.Slots internal slots;
    address internal emptyContract = vm.randomAddress();

    ContractLibLogic public contractLibLogic;
    ContractLibProxy public contractLibProxy;
    ExternalFunctions public externalFunctions;

    function setUp() public {
        contractLibLogic = new ContractLibLogic();
        contractLibProxy = new ContractLibProxy(address(contractLibLogic));
        externalFunctions = new ExternalFunctions();

        slots = getSlots();

        accounts.caller = createAccount("Caller");

        /// @dev Adds bytecode of empty contract to address.
        vm.etch(emptyContract, hex"60806040525f80fdfea164736f6c634300081a000a");
    }

    function createAccount(string memory name) internal returns (address payable newAccount) {
        newAccount = payable(makeAddr(name));
        vm.deal({ account: newAccount, newBalance: 1000 ether });
    }
}
