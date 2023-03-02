// import "./strings.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import  "./getprice.sol"; 

contract orderbase is GetPrice{
    //due to the lack of numbers with a dot, all coefficients are stored multiplied by 1000
    
    uint highestBid;
    uint lowestAsk;
    uint id;
    uint oibids;
    uint oiasks;
    uint period = 86400;

    //id to address
    mapping(uint => address) idBase;

    //id => coef
    mapping(uint => uint) askIds;
    mapping(uint => uint) bidIds;

    //Opened orders
    //game num => coef => id => value
    mapping(uint => mapping(uint => mapping(uint => uint))) askMain;
    mapping(uint => mapping(uint => mapping(uint => uint))) bidMain;


    function getHighestBid(uint x) public view returns(uint, uint){
        uint c;
        if(x == 0){x = n;}
        for(uint a; a != id+1; a+=1){
            c = c + bidMain[x][highestBid][a];
        }
        return(highestBid, c);
    }


    function getLowestAsk(uint x) public view returns(uint coef, uint value){    
        uint c;
        if(x == 0){x = n;}
        for(uint a; a != id+1; a+=1){
            c = c + askMain[x][lowestAsk][a];
        }
        return(lowestAsk, c); 
    }



    function renewHighestBids(uint x) internal{
        uint i = 0;
        uint cf; 
        if(x == 0){x = n;}
        while(i != id){
            i++;
            uint loc = bidIds[i];
            if(bidMain[x][loc][i] != 0){
                if(cf == 0){
                    cf = loc;
                }
                if(loc>cf){
                    cf = loc;
                }
            }
        }
        highestBid = cf;
    }
    

    function renewLowestAsk(uint x) internal{
        uint i = 0;
        uint cf;
        if(x == 0){x = n;} 
        while(i != id){
            i++;
            uint loc = askIds[i];
            if(askMain[x][loc][i] != 0){
                if(cf == 0){
                    cf = loc;
                }
                if(loc<cf){
                    cf = loc;
                }
            }
        }
        lowestAsk = cf;
    }

//filled orders
//id => coef => value
mapping(uint => mapping(uint => uint)) filledBids;
mapping(uint => mapping(uint => uint)) filledAsks;
}
