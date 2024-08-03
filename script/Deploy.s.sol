// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.26 <0.9.0;

import {Broadcaster} from "./Broadcaster.s.sol";
import {Environment} from "./Environment.s.sol";

contract Deploy is Broadcaster, Environment {
    /// @dev Deploys the Foo contract and optionally deploys a mock WETH contract in Test mode
    /// @return result The deployment result containing addresses of deployed contracts
    function run() public broadcast returns (DeploymentResult memory) {
        DeploymentMode mode = getDeploymentMode();

        result.foo = address(1);

        if (mode == DeploymentMode.Test) {}

        return result;
    }
}

/// @dev Note: The `result` variable should be defined as a global variable in the Environment contract
/// so that it can be modified and accessed across different deployments.
