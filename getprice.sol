// import "./strings.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract Automaticaly {
    AggregatorV3Interface internal BTCpriceFeed;
    AggregatorV3Interface internal ETHpriceFeed;
    AggregatorV3Interface internal LinkpriceFeed;
    uint public n = 0;
    uint public BTCUSD;
    uint time;
    AggregatorV3Interface internal priceFeed;


    constructor() {
        priceFeed = AggregatorV3Interface(
            0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        );
    }
    /**
    * Returns the latest price
    */
    function getLatestPrice() internal {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        BTCUSD = uint(price);
    }
}

    



contract GetPrice is Automaticaly {
    function gettime() public view returns(uint){
        return(time);
}

}
