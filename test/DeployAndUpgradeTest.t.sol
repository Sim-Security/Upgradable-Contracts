// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is StdCheats, Test {
    DeployBox public deployBox;
    UpgradeBox public upgradeBox;
    address public OWNER = address(1);

    // This function is executed before each test case
    function setUp() public {
        deployBox = new DeployBox();
        upgradeBox = new UpgradeBox();
    }

    // This test case checks if the initial deployment of BoxV1 contract is successful
    function testBoxWorks() public {
        address proxyAddress = deployBox.deployBox();
        uint256 expectedValue = 1;
        assertEq(expectedValue, BoxV1(proxyAddress).version());
    }

    // This test case checks if the deployment is still at version 1 (BoxV1) and fails when trying to set a value using BoxV2
    function testDeploymentIsV1() public {
        address proxyAddress = deployBox.deployBox();
        uint256 expectedValue = 7;
        vm.expectRevert(); // Expecting a revert when trying to set a value using BoxV2
        BoxV2(proxyAddress).setValue(expectedValue);
    }

    // This test case checks if the upgrade from BoxV1 to BoxV2 is successful
    function testUpgradeWorks() public {
        address proxyAddress = deployBox.deployBox();

        BoxV2 box2 = new BoxV2();

        vm.prank(BoxV1(proxyAddress).owner()); // Pretending to be the owner of BoxV1 contract
        BoxV1(proxyAddress).transferOwnership(msg.sender); // Transferring the ownership of BoxV1 contract to the sender

        address proxy = upgradeBox.upgradeBox(proxyAddress, address(box2)); // Upgrading from BoxV1 to BoxV2

        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).version()); // Checking if the version is now 2 (BoxV2)

        BoxV2(proxy).setValue(expectedValue); // Setting a value using BoxV2
        assertEq(expectedValue, BoxV2(proxy).getValue()); // Checking if the value is set correctly
    }
}
