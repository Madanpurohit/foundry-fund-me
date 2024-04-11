// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/AggregatorV3InterfaceMock.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaPriceFeedConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getEtheriumPriceFeedConfing();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getSepoliaPriceFeedConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({priceFeed: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43});
    }

    function getEtheriumPriceFeedConfing() public pure returns (NetworkConfig memory) {
        return NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();
        return NetworkConfig({priceFeed: address(mockV3Aggregator)});
    }
}
