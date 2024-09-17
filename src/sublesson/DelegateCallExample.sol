// SPDX-License-Identifier: MIT

// Be sure to check out solidity-by-example
// https://solidity-by-example.org/delegatecall

pragma solidity ^0.8.19;

// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint256 public num; // Public variable to store a number
    address public sender; // Public variable to store the address of the sender
    uint256 public value; // Public variable to store the value sent with the transaction

    // Function to set the variables
    function setVars(uint256 _num) public payable {
        num = _num; // Set the num variable to the provided value
        sender = msg.sender; // Set the sender variable to the address of the sender
        value = msg.value; // Set the value variable to the value sent with the transaction
    }
}

contract A {
    uint256 public num; // Public variable to store a number
    address public sender; // Public variable to store the address of the sender
    uint256 public value; // Public variable to store the value sent with the transaction

    // Function to set the variables using delegatecall
    function setVars(address _contract, uint256 _num) public payable {
        // A's storage is set, B is not modified.
        // (bool success, bytes memory data) = _contract.delegatecall(
        (bool success,) = _contract.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
        if (!success) {
            revert("delegatecall failed");
        }
    }
}
