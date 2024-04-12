// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundFundMe} from "../../script/Interaction.s.sol";

contract FundMeIntegretionTest is Test{
    address USER = makeAddr("user");
    uint256 constant INITIAL_VALUE = 10 ether;
    FundMe fundMe;
    function setUp() external{
        DeployFundMe deploy = new DeployFundMe();
        fundMe  = deploy.run();
    }
    function testUserCanFund() public{
        FundFundMe fundFundMe = new FundFundMe();
        hoax(USER,INITIAL_VALUE);
        fundFundMe.fundFundMe(address(fundMe));

        //assert
        assertEq(fundMe.funders(0),USER);
    }
}