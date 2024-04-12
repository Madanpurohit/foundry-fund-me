// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    address USER = makeAddr("user"); // generare random balance
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant INTIAL_VALUE = 10 ether;

    function setUp() external {
        fundMe = new DeployFundMe().run();
        vm.deal(USER, INTIAL_VALUE); // set intial balance
    }

    function testMinimumUsdIsFive() public view {
        assertEq(fundMe.minumumAmount(), 5e18);
    }

    function testIfOwnerIsContractCreator() public view {
        assertEq(fundMe.owner(), msg.sender);
    }

    function testVersionOfAggregatorVersion() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundShouldFailedIfAmmoutIsLessThenMinimum() public {
        vm.expectRevert(); // Next line should fail
        fundMe.fund();
    }

    function testFundShouldSuccess() public funded {
        uint256 amountFunded = fundMe.funderAmountMapping(USER);
        assertEq(SEND_VALUE, amountFunded);
    }

    function testAddFunderToArrayOfTheFunder() public funded {
        address funder = fundMe.funders(0);
        assertEq(USER, funder);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithOneFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //Act
        vm.prank(fundMe.owner());
        fundMe.withdraw();
        //Assert
        uint256 endingOwnerBalance = fundMe.owner().balance;
        uint256 endingFundBalance = address(fundMe).balance;

        assertEq(endingFundBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithDrawWithMultipleFunder() public {
        //Arrange
        uint160 numberOfFunders = 10; // Above solidity 0.8 we can only cast adderess in uint160 not in uint256;
        for (uint160 i = 1; i < numberOfFunders; i++) {
            //vm.prank
            //vm.deal(account, newBalance);
            hoax(address(i), INTIAL_VALUE); // its is combination of vm.prank and vm.deal
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //Act
        vm.prank(fundMe.owner());
        fundMe.withdraw();

        //assert
        uint256 endingOwnerBalance = fundMe.owner().balance;
        uint256 endingFundBalance = address(fundMe).balance;

        assertEq(endingFundBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }
}
