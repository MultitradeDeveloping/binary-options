// import "./strings.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./orderbase.sol"; 

contract orderSystem is orderbase{

function limitbid(uint coef, uint x) public payable{
    if(x == 0){x = n;}
    uint t = block.timestamp;
    uint treq = t%period;
    require(treq>60);
    id++;
    oibids = oibids + msg.value;
    idBase[id] = msg.sender;
    bidIds[id] = coef;
    bidMain[x][coef][id] = msg.value;
    if(highestBid < coef){
        highestBid = coef;
    }    
}


function limitask(uint coef, uint x) public payable{
    if(x == 0){x = n;}
    uint t = block.timestamp;
    uint treq = t%period;
    require(treq>60);
    id++;
    oiasks = oiasks + msg.value;
    idBase[id] = msg.sender; 
    askIds[id] = coef;
    askMain[x][coef][id] = msg.value;
    if(lowestAsk == 0){
        lowestAsk = coef;
    }
    if(lowestAsk > coef){
        lowestAsk = coef;
    }
}


function marketAsk(uint x) public payable{
    require(msg.value<=oibids, "Your order is more than supply in orderbook. Be careful to avoid squeeze");
    oibids = oibids - msg.value;
    id++;
    idBase[id] = msg.sender; 
    uint f = 0;
    uint a;
    if(x == 0){x = n;}
    while(f<msg.value){
        while(a<id){
            a++;
            //loc > supply at 1 order
            uint loc = bidMain[x][highestBid][a];
            if(loc > msg.value-f){
                bidMain[x][highestBid][a] = bidMain[x][highestBid][a]-(msg.value-f);
                askMain[x][highestBid][id] = msg.value-f;
                filledAsks[id][highestBid] = msg.value-f;
                filledBids[a][highestBid] = filledBids[a][highestBid] + (msg.value-f);
                f = msg.value;
            }

            //loc <= supply at 1 order
            else{
                bidMain[x][highestBid][a] = 0;
                askMain[x][highestBid][id] = msg.value-f;
                filledBids[a][highestBid] = filledBids[a][highestBid] + msg.value-f;
                filledAsks[id][highestBid] = msg.value-f;
                f = f+loc;         
            }

               
        }
        if(f<msg.value){
        a = 0;
        renewHighestBids(x);
        }
        

    }
}

function marketbid(uint x) public payable{

    require(msg.value<=oiasks, "Your order is more than supply in orderbook. Be careful to avoid squeeze");
    oiasks = oiasks - msg.value;
    id++;
    idBase[id] = msg.sender; 
    uint f = 0;
    uint a;
    while(f<msg.value){
        while(a<id){
            a++;
            //loc > supply at 1 order
            uint loc = askMain[x][lowestAsk][a];
            if(loc > msg.value-f){
                askMain[x][lowestAsk][a] = askMain[x][lowestAsk][a]-(msg.value-f);
                bidMain[x][lowestAsk][id] = msg.value-f;
                filledBids[id][lowestAsk] = msg.value-f;
                filledAsks[a][lowestAsk] = filledAsks[a][lowestAsk] + (msg.value-f);
                f = msg.value;
            }

            //loc <= supply at 1 order
            else{
                askMain[x][lowestAsk][a] = 0;
                bidMain[x][lowestAsk][id] = msg.value-f;
                filledAsks[a][lowestAsk] = filledAsks[a][lowestAsk] + msg.value-f;
                filledBids[id][lowestAsk] = msg.value-f;
                f = f+loc;         
            }

               
        }
        if(f<msg.value){
        a = 0;
        renewLowestAsk(x);
        }
    }
}




function cancelBid(uint value, uint coef, uint x) public {
uint i = 0;
address payable addr;
if(x == 0){x = n;}
while(addr != msg.sender){
    i++;
    addr = payable(idBase[i]);
}
uint val = bidMain[x][i][coef];
require(val>=value);
addr.transfer(value);
}

function cancelAsk(uint value, uint coef, uint x) public {
uint i = 0;
address payable addr;
if(x == 0){x = n;}
while(addr != msg.sender){
    i++;
    addr = payable(idBase[i]);
}
uint val = askMain[x][i][coef];
require(val>=value);
addr.transfer(value);
}
}
