// import "./strings.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./orderbase.sol"; 

contract orderSystem is orderbase{

function limitBid(uint coef) public payable{
    uint volume = msg.value ;
    if(volume  == 0){volume = n;}
    // uint t = block.timestamp;
    // uint treq = t%period;
    // require(treq>60);
    id = id+1;
    oibids = oibids + (msg.value*coef/1000);
    idBase[id] = msg.sender;
    bidIds[id] = coef;
    bidMain[n][coef][id] = msg.value;
    // xx = askMain[n][coef][id];
    if(highestBid < coef){
        highestBid = coef;
    }   
}

function limitask(uint coef) public payable{
    uint volume = msg.value ;
    if(volume  == 0){volume = n;}
    // uint t = block.timestamp;
    // uint treq = t%period;
    // require(treq>60);
    id = id+1;
    oiasks = oiasks + (msg.value*coef/1000);
    idBase[id] = msg.sender;
    askIds[id] = coef;
    askMain[n][coef][id] = msg.value;
    // xx = askMain[n][coef][id];
    if(lowestAsk < coef){
        lowestAsk = coef;
    }   
}

function marketbid() public payable{
    require(msg.value<=oiasks, "Your order is more than supply in orderbook. Be careful to avoid squeeze");
    oiasks = oiasks - msg.value;
    id = id+1;
    idBase[id] = msg.sender; 
    uint f = 0;
    uint a;
    while(f<msg.value){
        while(a<id){
            a = a+1;
            //loc > supply at 1 order 
            uint loc = askMain[n][lowestAsk][a];
            if(loc >= msg.value-f){
                askMain[n][lowestAsk][a] = askMain[n][lowestAsk][a]-(msg.value-f);
                bidIds[id] = lowestAsk;
                filledBids[id][lowestAsk] = msg.value;
                filledAsks[a][lowestAsk] = filledAsks[a][lowestAsk] + (msg.value-f);
                f = msg.value;

            }

            //loc <= supply at 1 order
            else{
                askMain[n][lowestAsk][a] = 0;
                filledAsks[a][lowestAsk] = filledAsks[a][lowestAsk] + msg.value-f;
                filledBids[id][lowestAsk] = msg.value;
                f = f+loc; 
                bidIds[id] = lowestAsk;
            }
               
        }
        if(f<msg.value){
        a = 0;
        f = msg.value;
        renewLowestAsk(msg.value);
        }
    }
}

function marketask() public payable{
	 require(msg.value<=oibids, "Your order is more than supply in orderbook. Be careful to avoid squeeze");
    oibids = oibids - msg.value;
    id = id+1;
    idBase[id] = msg.sender; 
    uint f = 0;
    uint a;
    while(f<msg.value){
        while(a<id){
            a = a+1;
            //loc > supply at 1 order 
            uint loc = bidMain[n][highestBid][a];
            if(loc >= msg.value-f){
                bidMain[n][highestBid][a] = bidMain[n][highestBid][a]-(msg.value-f);
                askIds[id] = highestBid;
                filledAsks[id][highestBid] = msg.value;
                filledBids[a][highestBid] = filledBids[a][highestBid] + (msg.value-f);
                f = msg.value;

            }

            //loc <= supply at 1 order
            else{
                bidMain[n][highestBid][a] = 0;
                filledBids[a][highestBid] = filledBids[a][highestBid] + msg.value-f;
                filledAsks[id][highestBid] = msg.value;
                f = f+loc; 
                askIds[id] = highestBid;
            }
               
        }
        if(f<msg.value){
        a = 0;
        f = msg.value;
        renewHighestBids(msg.value);
        }
    }
	}
	





function cancelBid(uint value, uint coef, uint volume) public {
uint i = 0;
address payable addr;
if(volume == 0){volume = n;}
while(addr != msg.sender){
    i = i+1;
    addr = payable(idBase[i]);
}
uint val = bidMain[n][highestBid][id];
require(val>=value);
addr.transfer(value);
}

function cancelask(uint value, uint coef, uint volume) public {
uint i = 0;
address payable addr;
if(volume == 0){volume = n;}
while(addr != msg.sender){
    i = i+1;
    addr = payable(idBase[i]);
}
uint val = askMain[n][highestBid][id];
require(val>=value);
addr.transfer(value);
}
}
