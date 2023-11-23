// import "./strings.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./orderbase.sol"; 

contract orderSystem is orderbase{

function limitbid(uint coef) public payable{
    id = id+1;
    idBaseReversed[msg.sender].push(id);
    uint volume = msg.value ;
    if(volume  == 0){volume = n;}
    // uint t = block.timestamp;
    // uint treq = t%period;
    // require(treq>60);
    oibids = oibids + (msg.value*coef/1000);
    idBase[id] = msg.sender;
    bidCoefs[id] = coef;
    bidValue[id] = msg.value;
    // xx = askMain[n][coef][id];
    if(highestBid < coef){
        highestBid = coef;
    }    
    
}

function limitask(uint coef) public payable{
    id = id+1;
    idBaseReversed[msg.sender].push(id);
    uint volume = msg.value ;
    if(volume  == 0){volume = n;}
    // uint t = block.timestamp;
    // uint treq = t%period;
    // require(treq>60);
    oiasks = oiasks + (msg.value*coef/1000);
    idBase[id] = msg.sender;
    askCoefs[id] = coef;
    askValue[id] = msg.value;
    // xx = askMain[n][coef][id];
    if(lowestAsk > coef){
        lowestAsk = coef;
    }   
    
}

function marketbid() public payable{
    require(msg.value<=oiasks, "Your order is more than supply in orderbook. Be careful to avoid squeeze");
    oiasks = oiasks - msg.value;
    id = id+1;
    idBaseReversed[msg.sender].push(id);
    idBase[id] = msg.sender; 
    uint await;
    uint f = 0;
    uint locCoef;
    bidValue[id] = msg.value;
    while(f<msg.value){
        renewLowestAsk(1);
        uint a;
        while(locCoef != lowestAsk){
            locCoef = askCoefs[a+1];
            a++;
        }
        
        // if(locCoef == 0){locCoef = 1000;}
        //coef for ask
        uint fullvalue = (msg.value-f)*locCoef/1000;

        //не разъедает
        if(askValue[a]-askFilled[a] > (msg.value - f)/locCoef*1000){
            bidFilled[id] = msg.value;
            askFilled[a] = askFilled[a] + fullvalue;
            // await = await + (msg.value - f)/locCoef*1000;
            await = await + fullvalue;
            f = msg.value;
            }

        //разъедает
        else{
            askFilled[a] = askValue[a];
            bidFilled[id]  = bidFilled[id] + (msg.value - f)/locCoef*1000;
            // await = await + (msg.value - f)/locCoef*1000;
            await = await + fullvalue;
            f = f + fullvalue + (msg.value - f)/locCoef*1000;
        }


    }
    bidCoefs[id] = 1000*(await/msg.value);
    
}

function marketask() public payable{
    require(msg.value<=oibids, "Your order is more than supply in orderbook. Be careful to avoid squeeze");
    oibids = oibids - msg.value;
    id = id+1;
    idBaseReversed[msg.sender].push(id);
    idBase[id] = msg.sender; 
    uint await;
    uint f = 0;
    uint locCoef;
    askValue[id] = msg.value;
    while(f<msg.value){
        renewHighestBids(1);
        uint a;
        while(locCoef != highestBid){
            locCoef = bidCoefs[a+1];
            a++;
        }
        
        // if(locCoef == 0){locCoef = 1000;}
        //coef for ask
        uint fullvalue = (msg.value-f)*locCoef/1000;

        //не разъедает
        if(bidValue[a]-bidFilled[a] > (msg.value - f)/locCoef*1000){
            askFilled[id] = msg.value;
            bidFilled[a] = bidFilled[a] + fullvalue;
            // await = await + (msg.value - f)/locCoef*1000;
            await = await + fullvalue;
            f = msg.value;
            }

        //разъедает
        else{
            bidFilled[a] = bidValue[a];
            askFilled[id]  = askFilled[id] + (msg.value - f)/locCoef*1000;
            // await = await + (msg.value - f)/locCoef*1000;
            await = await + fullvalue;
            f = f + fullvalue + (msg.value - f)/locCoef*1000;
        }


    }
    askCoefs[id] = 1000*(await/msg.value);
    
}
	





function cancelBid(uint id, uint volume) public {
    require(bidValue[id] >= volume);
    bidValue[id] = bidValue[id] - volume;
    }



function cancelask(uint id,  uint volume) public {
    require(askValue[id] >= volume);
    askValue[id] = askValue[id] - volume;
}
}
