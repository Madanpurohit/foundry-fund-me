// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library Conversion {
    function getPrice(AggregatorV3Interface dataFeeder) internal view returns (uint256) {
        (
            /* uint80 roundID */
            ,
            int256 answer,
            /*uint startedAt*/
            ,
            /*uint timeStamp*/
            ,
            /*uint80 answeredInRound*/
        ) = dataFeeder.latestRoundData();
        return uint256(answer) * 1e8;
    }

    function getConversionRate(uint256 value, AggregatorV3Interface dataFeeder) internal view returns (uint256) {
        return value * getPrice(dataFeeder);
    }

    function getVesrion(AggregatorV3Interface dataFeeder) internal view returns (uint256) {
        return dataFeeder.version();
    }
}
