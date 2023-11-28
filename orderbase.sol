// import "./strings.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import  "./getprice.sol"; 

contract orderbase is GetPrice{
    //due to the lack of numbers with a dot, all coefficients are stored multiplied by 1000
    
    uint public highestBid;
    uint public lowestAsk = 10**9;
    uint public id;
    uint public oibids;
    uint public oiasks;
    uint period = 60;

    //id to address
    mapping(uint => address) idBase;
    mapping(address => uint[]) idBaseReversed;

    //id => coef
    mapping(uint => uint) askCoefs;
    mapping(uint => uint) bidCoefs;

    //id => value
    mapping(uint => uint) askValue;
    mapping(uint => uint) bidValue;

    //id => value filled
    mapping(uint => uint) askFilled;
    mapping(uint => uint) bidFilled;
    
    uint[] public nearestAsks = [0,0];
    uint[] public nearestBids = [0, 0];

    function createAskOB(uint limit) public {
    uint i;
    uint len = nearestAsks.length;

    if (limit < nearestAsks[len-1]) {
        while (i != len) {
            if (limit <= nearestAsks[i]) {
                nearestAsks.push(0);
                for (uint j = nearestAsks.length - 1; j > i; j--) {
                    nearestAsks[j] = nearestAsks[j - 1];
                }
                nearestAsks[i] = limit;
                break;
            }
            i = i + 1;
        }
    } else {
        nearestAsks.push(0);  // Добавляем временный элемент в конец массива

        for (i = len; i > 0 && limit < nearestAsks[i - 1]; i--) {
            nearestAsks[i] = nearestAsks[i - 1];
        }

        nearestAsks[i] = limit;  // Вставляем новый элемент в нужное место

        // Удаляем временный элемент
        nearestAsks.pop();
    }
}

    
    function createBidOB(uint limit) public {
    uint i;
    uint len = nearestAsks.length;

    if (limit < nearestAsks[len-1]) {
        while (i != len) {
            if (limit <= nearestAsks[i]) {
                nearestAsks.push(0);
                for (uint j = nearestAsks.length - 1; j > i; j--) {
                    nearestAsks[j] = nearestAsks[j - 1];
                }
                nearestAsks[i] = limit;
                break;
            }
            i = i + 1;
        }
    } else {
        nearestAsks.push(0);  // Добавляем временный элемент в конец массива

        for (i = len; i > 0 && limit < nearestAsks[i - 1]; i--) {
            nearestAsks[i] = nearestAsks[i - 1];
        }

        nearestAsks[i] = limit;  // Вставляем новый элемент в нужное место

        // Удаляем временный элемент
        nearestAsks.pop();
    }
}


    //to make tradelist
    function getAddressOrdersNum(address address_) public view returns(uint ordersNum){
        uint a = idBaseReversed[address_].length;
        return(a);
    }

    function getIdsOfOrders(address address_, uint n) public view returns(uint idNum){
        uint a = idBaseReversed[address_][n];
        return(a);
    }


    //side LONG = 1, SHORT = 0
    function getDataByID(uint n) public view returns(uint coef, uint side, uint value, uint filled){
        uint valbids = bidValue[n];
        uint valasks = askValue[n];    
        if(valbids != 0){
            return(bidCoefs[n], 1, valbids, bidFilled[n]);
        }
        else{
            return(askCoefs[n], 0, valasks, askFilled[n]);
        }

    }

    function calculateAverageAskCoef(uint volume) public view returns(uint){
        if(volume > oiasks){return(0);}
        else{
            //spent by market order
            uint spend;
            uint fill;
            uint highestUsedCoef;
            while(spend < volume){
                uint i;
                uint localId;
                uint LocalCoef = 65535;
                while(i<=id){
                    i++;
                    if(askCoefs[i] <= LocalCoef && askCoefs[i] > highestUsedCoef && askFilled[i]-askValue[i] != 0){
                        LocalCoef = askCoefs[i];
                        highestUsedCoef = LocalCoef;
                        localId = i;
                       }

                }
                
                uint add = askValue[i]; 
                if(add <= volume-spend){ 
                    fill = fill+add;
                    spend = spend + (add*LocalCoef/1000);
                }
                else{
                    fill = fill + (volume - spend)*1000/LocalCoef;
                    spend = volume;
                }
                
            }   
            return((1000*fill)/spend);
        }
            

    }

    function calculateAverageBidCoef(uint volume) public view returns(uint){
        if(volume > oibids){return(0);}
        else{
            //spent by market order
            uint spend;
            uint fill;
            uint lowestUsedCoef;
            while(spend < volume){
                uint i;
                uint localId;
                uint LocalCoef;
                while(i<=id){
                    i++;
                    if(bidCoefs[i] >= LocalCoef && bidCoefs[i] > lowestUsedCoef && bidFilled[i] - bidValue[i] != 0){
                        LocalCoef = bidCoefs[i];
                        lowestUsedCoef = LocalCoef;
                        localId = i;
                       }

                }
                
                uint add = bidValue[i]; 
                if(add <= volume-spend){ 
                    fill = fill+add;
                    spend = spend + (add*LocalCoef/1000);
                }
                else{
                    fill = fill + (volume - spend)*1000/LocalCoef;
                    spend = volume;
                }
                
            }
            return((1000*fill)/spend);
        }
            

    }



    function renewHighestBids(uint volume) internal{
        uint i = 0;
        uint cf; 
        if(volume == 0){volume = n;}
        while(i != id){
            i = i+1;
            uint loc = bidCoefs[i];
            if(bidValue[i] != 0){
                if(cf == 0){
                    cf = loc;
                }
                if(loc>cf){
                    cf = loc;
                }
            }
            if(i>=id){break;}
        }
        highestBid = cf;
    }
    

    function renewLowestAsk(uint volume) internal{
        uint i = 0;
        uint cf;
        if(volume == 0){volume = n;} 
        while(i != id){
            i = i+1;
            uint loc = askCoefs[i];
            if(askValue[i] != 0){
                if(cf == 0){
                    cf = loc;
                }
                if(loc<cf){
                    cf = loc;
                }
            }

            if(i>=id){break;}
        }
        lowestAsk = cf;
    }


}
