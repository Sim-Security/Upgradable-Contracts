// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract UpgradeBox is Script {
    /**
     * @dev Executes the upgrade process for the Box contract.
     * @return The address of the upgraded proxy contract.
     */
    function run() external returns (address) {
        // Get the most recently deployed proxy contract address for ERC1967Proxy.
        address mostRecentlyDeployedProxy = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        // Start the broadcast to capture the state changes.
        vm.startBroadcast();

        // Deploy a new instance of BoxV2 contract.
        BoxV2 newBox = new BoxV2();

        // Stop the broadcast to finalize the state changes.
        vm.stopBroadcast();

        // Upgrade the Box contract by calling the upgradeBox function.
        address proxy = upgradeBox(mostRecentlyDeployedProxy, address(newBox));

        // Return the address of the upgraded proxy contract.
        return proxy;
    }

    /**
     * @dev Upgrades the Box contract by replacing the implementation address of the proxy contract.
     * @param proxyAddress The address of the proxy contract.
     * @param newBox The address of the new Box contract implementation.
     * @return The address of the upgraded proxy contract.
     */
    function upgradeBox(address proxyAddress, address newBox) public returns (address) {
        // Start the broadcast to capture the state changes.
        vm.startBroadcast();

        // Create a BoxV1 instance from the proxy contract address.
        BoxV1 proxy = BoxV1(payable(proxyAddress));

        // Upgrade the proxy contract to use the new Box contract implementation.
        proxy.upgradeTo(address(newBox));

        // Stop the broadcast to finalize the state changes.
        vm.stopBroadcast();

        // Return the address of the upgraded proxy contract.
        return address(proxy);
    }
}
