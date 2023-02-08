// import "./strings.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import  "./contract.sol"; 

contract orderbase is GetPrice{
    //due to the lack of numbers with a dot, all coefficients are stored multiplied by 1000
    
    int highestBid;
    int lowestAsk;
    uint id;

    //id to address
    mapping(uint id => address) idbase;
    //Opened orders
    mapping(int coef => mapping(uint id => int value)) askmain;
    mapping(int coef => mapping(uint id => int value)) bidmain;


    function getHighestBid() public view returns(int, int){
        int c;
        for(uint a; a != id+1; a+=1){
            c = c + bidmain[highestBid][a];
        }
        return(highestBid, c);
    }



    function getLowestAsk() public view returns(int coef, int value){    
        int c;
        for(uint a; a != id+1; a+=1){
            c = c + bidmain[highestBid][a];
        }
        return(highestBid, c); 
    }
}
