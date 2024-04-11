// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Conversion} from "./ConversionLibrary.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{
    using Conversion for uint256;
    uint256 public constant minumumAmount = 5e18;
    address[] public funders;
    mapping(address funderAddress => uint256 amount) public funderAmountMapping;
    address public immutable owner;
    AggregatorV3Interface private s_priceFeed;
    constructor(address priceFeed){
        owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() payable public  {
        require(msg.value.getConversionRate(s_priceFeed) >= minumumAmount,"Can't send less the 5 USD");
        funderAmountMapping[msg.sender] = msg.value;
        funders.push(msg.sender);
    }

    function withdraw() public onlyOwner{

        for(uint256 index = 0;index<funders.length;index++){
            funderAmountMapping[funders[index]] = 0;
        }
        funders = new address[](0);
        // using transfer methed it will give error and revert the transaction if gas value is more then 23k
        //payable(msg.sender).transfer(address(this).balance);

        // bool isSent = payable(msg.sender).send(address(this).balance);
        // it won't gives error it will give true and false(gas > 23k)
        // require(isSent,"Amount is not transfered");

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        // Uses Ullimated gas
        require(callSuccess,"Amount is not transfered");
    }

    function getVersion() public view returns(uint256){
        return Conversion.getVesrion(s_priceFeed);
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"Only Owner Allowed");
        _;
    }

    // what happens if someone not call the fund method and directly send the money to the contract 

    receive() external payable {
        fund();
     }

     fallback() external payable { 
        fund();
     }
}