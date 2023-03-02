
contract Automaticaly {
    
    AggregatorV3Interface internal BTCpriceFeed;
    AggregatorV3Interface internal ETHpriceFeed;
    AggregatorV3Interface internal LinkpriceFeed;
    uint public n = 0;
    uint public BTCUSD;
    uint time;
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
        BTCUSD = uint(price);
        time = timeStamp;
        // time[n] = uint80(startedAt);
    }
}




contract GetPrice is Automaticaly {
    function gettime() public view returns(uint){
        return(time);
}


}
