// import "./strings.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Automaticaly {
    
    AggregatorV3Interface internal BTCpriceFeed;
    AggregatorV3Interface internal ETHpriceFeed;
    AggregatorV3Interface internal LinkpriceFeed;
    uint n = 0;
    mapping(uint => int) BTCUSD;
    mapping(uint => uint80) time;
    constructor() {
        BTCpriceFeed = AggregatorV3Interface(0xA39434A63A52E749F02807ae27335515BA4b07F7);
        ETHpriceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        LinkpriceFeed = AggregatorV3Interface(0x48731cF7e84dc94C5f84577882c14Be11a5B7456);
    }
    function LatestBTCprice() public{
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = BTCpriceFeed.latestRoundData();
        n++;
        BTCUSD[n] = price;
        time[n] = roundID;
    }
}

contract GetPrice is Automaticaly {
    
    function getBTC(uint i) public view returns(int){
        if(i == 0){
            return(BTCUSD[n]);}
        else{
            return(BTCUSD[i]);   
        }

    }

    function gettime(uint i) public view returns(uint80){
        if(i == 0){
            return(time[n]);}
        else{
            return(time[i]);   
        }

    }



}
