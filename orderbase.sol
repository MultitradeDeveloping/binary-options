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

    //id => coefw
    mapping(uint => uint) askIds;
    mapping(uint => uint) bidIds;

    //Opened orders
    //game num => coef => id => value
    mapping(uint => mapping(uint => mapping(uint => uint))) askMain;
    mapping(uint => mapping(uint => mapping(uint => uint))) bidMain;


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
                    if(askIds[i] <= LocalCoef && askIds[i] > highestUsedCoef && askMain[n][askIds[i]][i] != 0){
                        LocalCoef = askIds[i];
                        highestUsedCoef = LocalCoef;
                        localId = i;
                       }

                }
                
                uint add = askMain[n][LocalCoef][localId]; 
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
                    if(bidIds[i] >= LocalCoef && bidIds[i] > lowestUsedCoef && bidMain[n][bidIds[i]][i] != 0){
                        LocalCoef = bidIds[i];
                        lowestUsedCoef = LocalCoef;
                        localId = i;
                       }

                }
                
                uint add = bidMain[n][LocalCoef][localId]; 
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
            uint loc = bidIds[i];
            if(bidMain[volume][loc][i] != 0){
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
            uint loc = askIds[i];
            if(askMain[volume][loc][i] != 0){
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

//filled orders
//id => coef => value
mapping(uint => mapping(uint => uint)) filledBids;
mapping(uint => mapping(uint => uint)) filledAsks;
}
