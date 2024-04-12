// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";
contract FundFundMe is Script{
    uint256 constant SEND_VALUE  = 0.01 ether;

    function fundFundMe(address mostRecentDeployment) public{
        //console.log(mostRecentDeployment);
        console.log("balance is ",msg.sender.balance);
        console.log("Sender is ",msg.sender);
        FundMe(payable(mostRecentDeployment)).fund{value: 1e5}();    
        }
    function run() external{
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        FundFundMe(mostRecentDeployment);
        vm.stopBroadcast();
        console.log(mostRecentDeployment);
    }
}