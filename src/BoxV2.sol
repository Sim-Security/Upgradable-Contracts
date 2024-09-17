// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title BoxV2
 * @dev This contract represents a simple storage contract that allows setting and getting a value.
 * It is an upgradable contract that inherits from OwnableUpgradeable and UUPSUpgradeable.
 */
contract BoxV2 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 internal value;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Initializes the contract by calling the initializers of the inherited contracts.
     */
    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    /**
     * @dev Sets the value of the storage.
     * @param newValue The new value to be set.
     */
    function setValue(uint256 newValue) public {
        value = newValue;
    }

    /**
     * @dev Gets the current value from the storage.
     * @return The current value.
     */
    function getValue() public view returns (uint256) {
        return value;
    }

    /**
     * @dev Returns the version of the contract.
     * @return The version number.
     */
    function version() public pure returns (uint256) {
        return 2;
    }

    /**
     * @dev Overrides the _authorizeUpgrade function from UUPSUpgradeable to only allow the owner to upgrade the contract.
     * @param newImplementation The address of the new implementation contract.
     */
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
