// import "./strings.sol";
// SPDX-License-Identifier: MIT
import "./takeprofit.sol";
pragma solidity ^0.8.0;


contract cycle is takeprofit{   
    function clean() internal  {
    uint a ;
    uint b;
    while(a<=id){
        a = a+1;
        if(askValue[a] != 0){
            address payable addr = payable(idBase[a]);
            addr.transfer(askValue[a]);
        }
        if(bidValue[a] != 0){
            address payable addr = payable(idBase[a]);
            addr.transfer(bidValue[a]);
        }
        while(b<=idBaseReversed[idBase[a]].length){
            idBaseReversed[idBase[a]][b] = 0;
            b++;
        }
        idBase[a] = 0x0000000000000000000000000000000000000000;        
        askValue[a] = 0;
        bidValue[a] = 0;
        askFilled[a] = 0;
        bidFilled[a] = 0;
        askCoefs[a] = 0;
        bidCoefs[a] = 0;
        // test++;
    }
    highestBid = 0;
    lowestAsk = 0;
    oibids = 0;
    oiasks = 0;
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
        getLatestPrice(); //from getprice.sol 
        if(BTCUSD>last){
            take(true);   
        }
        else{
            take(false);
        }
        clean();    
    }


    function test(bool up) public{
        take(up);
        clean();
    }
}
