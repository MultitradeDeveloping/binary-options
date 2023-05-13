// import "./strings.sol";
// SPDX-License-Identifier: MIT
import "./takeprofit.sol";
pragma solidity ^0.8.0;


contract cycle is takeprofit{   
    address public owner = msg.sender;

    function clean() public {
    uint a ;
    while(a<=id){
        a = a+1;
        if(askMain[n][a][askIds[a]] != 0){
            address payable addr = payable(idBase[a]);
            addr.transfer(askMain[n][a][askIds[a]]);
        }
        if(bidMain[n][a][bidIds[a]] != 0){
            address payable addr = payable(idBase[a]);
            addr.transfer(bidMain[n][a][bidIds[a]]);
        }
        idBase[a] = 0x0000000000000000000000000000000000000000;        
        askMain[n][askIds[a]][id] = 0;
        bidMain[n][bidIds[a]][id] = 0;
        filledAsks[askIds[a]][a] = 0;
        filledBids[bidIds[a]][a] = 0;
        askIds[a] = 0;
        bidIds[a] = 0;
    }
    highestBid = 0;
    lowestAsk = 0;
    id = 0;
    n = n+1;
    feeManagement();
    }
    


    function feeManagement() internal{
        if(n%10==0){
            address payable _owner = payable(owner);
            _owner.transfer(address(this).balance);
        }
        
    }

    function screen() public{
        uint t = block.timestamp;
        uint treq = t%period;
        require(treq<60, "reverted by time requirement");
        uint last = BTCUSD;
        // getLatestPrice(); //from getprice.sol 
        if(BTCUSD>last){
            take(true);   
        }
        else{
            take(false);
        }
        clean();
    }

}
