// import "./strings.sol";
// SPDX-License-Identifier: MIT
import "./takeprofit.sol";
pragma solidity ^0.8.0;


contract cycle is takeprofit{    
    function clean() internal{
    uint a;
    while(a<id){
        a++;
        if(askMain[n][a][askIds[a]] != 0){
            address payable addr = payable(idBase[a]);
            addr.transfer(askMain[n][a][askIds[a]]);
        }
        if(bidMain[n][a][bidIds[a]] != 0){
            address payable addr = payable(idBase[a]);
            addr.transfer(bidMain[n][a][bidIds[a]]);
        }
        idBase[a] = 0x0000000000000000000000000000000000000000;        
        askMain[n][a][askIds[a]] = 0;
        bidMain[n][a][bidIds[a]] = 0;
        filledAsks[askIds[a]][a] = 0;
        filledBids[bidIds[a]][a] = 0;
        askIds[a] = 0;
        bidIds[a] = 0;
    }
    highestBid = 0;
    lowestAsk = 0;
    id = 0;
    n++;
    }
    
    function screen() public{
        uint t = block.timestamp;
        uint treq = t%period;
        require(treq<60);
        uint last = BTCUSD;
        LatestBTCprice(); //from getprice.sol 
        if(BTCUSD>last){
            take(true);   
        }
        else{
            take(false);
        }
        clean();

    }

}
