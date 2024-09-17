// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBox is Script {
    /**
     * @dev Executes the deployment of the Box contract using an upgradeable proxy pattern.
     * @return The address of the deployed proxy contract.
     */
    function run() external returns (address) {
        address proxy = deployBox();
        return proxy;
    }

    /**
     * @dev Deploys the Box contract and initializes it using an upgradeable proxy pattern.
     * @return The address of the deployed proxy contract.
     */
    function deployBox() public returns (address) {
        vm.startBroadcast();
        BoxV1 box = new BoxV1(); // Creates a new instance of the BoxV1 contract
        ERC1967Proxy proxy = new ERC1967Proxy(address(box), ""); // Creates a new instance of the ERC1967Proxy contract, using the BoxV1 contract as the implementation
        BoxV1(address(proxy)).initialize(); // Initializes the BoxV1 contract through the proxy
        vm.stopBroadcast();
        return address(proxy); // Returns the address of the deployed proxy contract
    }
}
