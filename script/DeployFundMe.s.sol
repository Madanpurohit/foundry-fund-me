// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script{
    function run() external returns(FundMe) {
        vm.startBroadcast();
        FundMe fundMe = new FundMe(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43);
        vm.stopBroadcast();
        return fundMe;
    }
}