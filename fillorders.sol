// import "./strings.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import  "./contract.sol"; 
import "./orderbase.sol"; 

contract orderSystem is orderbase{

function limitbid(uint coef) public payable{
    id++;
    idBase[id] = msg.sender; 
    bidIds[id] = coef;
    bidMain[coef][id] = msg.value;
    if(highestBid < coef){
        highestBid = coef;
    }    
}


function limitask(uint coef) public payable{
    id++;
    idBase[id] = msg.sender; 
    askIds[id] = coef;
    askMain[coef][id] = msg.value;
    if(lowestAsk == 0){
        lowestAsk = coef;
    }
    if(lowestAsk > coef){
        lowestAsk = coef;
    }
}


function marketAsk() public payable{
    id++;
    idBase[id] = msg.sender; 
    uint f = 0;
    uint a;
    while(f<msg.value){
        while(a<id){
            a++;
            //loc > supply at 1 order
            uint loc = bidMain[highestBid][a];
            if(loc > msg.value-f){
                bidMain[highestBid][a] = bidMain[highestBid][a]-(msg.value-f);
                askMain[highestBid][id] = msg.value-f;
                filledAsks[id][highestBid] = msg.value-f;
                filledBids[a][highestBid] = filledBids[a][highestBid] + (msg.value-f);
                f = msg.value;
            }

            //loc <= supply at 1 order
            else{
                bidMain[highestBid][a] = 0;
                askMain[highestBid][id] = msg.value-f;
                filledBids[a][highestBid] = filledBids[a][highestBid] + msg.value-f;
                filledAsks[id][highestBid] = msg.value-f;
                f = f+loc;         
            }

               
        }
        if(f<msg.value){
        a = 0;
        renewHighestBids();
        }
        

    }
    }







function marketbid() public payable{
    id++;
    idBase[id] = msg.sender; 
    uint f = 0;
    uint a;
    while(f<msg.value){
        while(a<id){
            a++;
            //loc > supply at 1 order
            uint loc = askMain[lowestAsk][a];
            if(loc > msg.value-f){
                askMain[lowestAsk][a] = askMain[lowestAsk][a]-(msg.value-f);
                bidMain[lowestAsk][id] = msg.value-f;
                filledBids[id][lowestAsk] = msg.value-f;
                filledAsks[a][lowestAsk] = filledAsks[a][lowestAsk] + (msg.value-f);
                f = msg.value;
            }

            //loc <= supply at 1 order
            else{
                askMain[lowestAsk][a] = 0;
                bidMain[lowestAsk][id] = msg.value-f;
                filledAsks[a][lowestAsk] = filledAsks[a][lowestAsk] + msg.value-f;
                filledBids[id][lowestAsk] = msg.value-f;
                f = f+loc;         
            }

               
        }
        if(f<msg.value){
        a = 0;
        renewLowestAsk();
        }
        

    }
    }
}
