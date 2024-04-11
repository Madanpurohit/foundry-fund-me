// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
contract FundMeTest is Test{
    FundMe public fundMe;
    function setUp() external{
        fundMe = new DeployFundMe().run();
    }

    function testMinimumUsdIsFive() public view{
        assertEq(fundMe.minumumAmount(), 5e18);
    }

    function testIfOwnerIsContractCreator() public view {
        assertEq(fundMe.owner(),msg.sender);
    }

    function testVersionOfAggregatorVersion() public view{
        assertEq(fundMe.getVersion(), 4);
    }
}