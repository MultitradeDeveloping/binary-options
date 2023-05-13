// import "./strings.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import  "./getprice.sol"; 

contract orderbase is GetPrice{
    //due to the lack of numbers with a dot, all coefficients are stored multiplied by 1000
    
    uint public highestBid;
    uint public lowestAsk;
    uint public id;
    uint public oibids;
    uint public oiasks;
    uint period = 60;

    //id to address
    mapping(uint => address) idBase;

    //id => coef
    mapping(uint => uint) askIds;
    mapping(uint => uint) bidIds;

    //Opened orders
    //game num => coef => id => value
    mapping(uint => mapping(uint => mapping(uint => uint))) askMain;
    mapping(uint => mapping(uint => mapping(uint => uint))) bidMain;


    function getHighestBid(uint volume) public view returns(uint, uint){
        
        uint c;
        if(volume == 0){volume = n;}
        for(uint a; a != id+1; a+=1){
            c = c + bidMain[volume][highestBid][a];
        }
        return(highestBid, c);
    }


    function getLowestAsk(uint volume) public view returns(uint coef, uint value){    
        
        uint c;
        if(volume == 0){volume = n;}
        for(uint a; a != id+1; a+=1){
            c = c + askMain[volume][lowestAsk][a];
        }
        return(lowestAsk, c); 
    }



    function renewHighestBids(uint volume) internal{
        uint i = 0;
        uint cf; 
        if(volume == 0){volume = n;}
        while(i != id){
            i = i+1;
            uint loc = bidIds[i];
            if(bidMain[volume][loc][i] != 0){
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
    

    function renewLowestAsk(uint volume) internal{
        uint i = 0;
        uint cf;
        if(volume == 0){volume = n;} 
        while(i != id){
            i = i+1;
            uint loc = askIds[i];
            if(askMain[volume][loc][i] != 0){
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
