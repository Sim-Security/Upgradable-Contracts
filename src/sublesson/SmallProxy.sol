// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/proxy/Proxy.sol";

/**
 * @title SmallProxy
 * @dev A transparent proxy contract that allows only admins to call functions on the proxy.
 * If anyone else tries to call a function, they will be redirected to the fallback contract.
 */
contract SmallProxy is Proxy {
    // This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @dev Sets the implementation address for the proxy contract.
     * @param newImplementation The address of the new implementation contract.
     */
    function setImplementation(address newImplementation) public {
        assembly {
            sstore(_IMPLEMENTATION_SLOT, newImplementation)
        }
    }

    /**
     * @dev Returns the implementation address for the proxy contract.
     * @return implementationAddress The address of the implementation contract.
     */
    function _implementation() internal view override returns (address implementationAddress) {
        assembly {
            implementationAddress := sload(_IMPLEMENTATION_SLOT)
        }
    }

    /**
     * @dev Returns the encoded function call data to update the value in the implementation contract.
     * @param numberToUpdate The new value to be set.
     * @return The encoded function call data.
     */
    function getDataToTransact(uint256 numberToUpdate) public pure returns (bytes memory) {
        return abi.encodeWithSignature("setValue(uint256)", numberToUpdate);
    }

    /**
     * @dev Reads the value stored at storage slot zero.
     * @return valueAtStorageSlotZero The value stored at storage slot zero.
     */
    function readStorage() public view returns (uint256 valueAtStorageSlotZero) {
        assembly {
            valueAtStorageSlotZero := sload(0)
        }
    }
}

/**
 * @title ImplementationA
 * @dev An implementation contract that sets the value without any modification.
 */
contract ImplementationA {
    uint256 public value;

    /**
     * @dev Sets the value to the new value.
     * @param newValue The new value to be set.
     */
    function setValue(uint256 newValue) public {
        value = newValue;
    }
}

/**
 * @title ImplementationB
 * @dev An implementation contract that sets the value by adding 2 to the new value.
 */
contract ImplementationB {
    uint256 public value;

    /**
     * @dev Sets the value to the new value plus 2.
     * @param newValue The new value to be set.
     */
    function setValue(uint256 newValue) public {
        value = newValue + 2;
    }
}

// function setImplementation(){}
// Transparent Proxy -> Ok, only admins can call functions on the proxy
// anyone else ALWAYS gets sent to the fallback contract.

// UUPS -> Where all upgrade logic is in the implementation contract, and
// you can't have 2 functions with the same function selector.
