// import "./strings.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import  "./contract.sol"; 

contract orderbase is GetPrice{
    //due to the lack of numbers with a dot, all coefficients are stored multiplied by 1000
    
    uint highestBid;
    uint lowestAsk;
    uint id;
    uint oibids;
    uint oiasks;

    //id to address
    mapping(uint => address) idBase;

    //id => coef
    mapping(uint => uint) askIds;
    mapping(uint => uint) bidIds;

    //Opened orders
    //coef => id => value
    mapping(uint => mapping(uint => uint)) askMain;
    mapping(uint => mapping(uint => uint)) bidMain;


    function getHighestBid() public view returns(uint, uint){
        uint c;
        for(uint a; a != id+1; a+=1){
            c = c + bidMain[highestBid][a];
        }
        return(highestBid, c);
    }


    function getLowestAsk() public view returns(uint coef, uint value){    
        uint c;
        for(uint a; a != id+1; a+=1){
            c = c + askMain[lowestAsk][a];
        }
        return(lowestAsk, c); 
    }



    function renewHighestBids() internal{
        uint i = 0;
        uint cf; 
        while(i != id){
            i++;
            uint loc = bidIds[i];
            if(bidMain[loc][i] != 0){
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
    

    function renewLowestAsk() internal{
        uint i = 0;
        uint cf; 
        while(i != id){
            i++;
            uint loc = askIds[i];
            if(askMain[loc][i] != 0){
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
