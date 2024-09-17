// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title BoxV1
 * @dev This contract represents a simple storage contract that allows users to store and retrieve a single value.
 */
contract BoxV1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 internal value;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Initializes the contract.
     * This function is called only once during contract deployment.
     */
    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    /**
     * @dev Retrieves the stored value.
     * @return The stored value.
     */
    function getValue() public view returns (uint256) {
        return value;
    }

    /**
     * @dev Retrieves the contract version.
     * @return The contract version.
     */
    function version() public pure returns (uint256) {
        return 1;
    }

    /**
     * @dev Authorizes the upgrade to a new implementation contract.
     * Only the contract owner can authorize the upgrade.
     * @param newImplementation The address of the new implementation contract.
     */
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    // Add any additional functions or modifiers here
}
