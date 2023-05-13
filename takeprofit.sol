// import "./strings.sol";
// SPDX-License-Identifier: MIT
import "./fillorders.sol";
pragma solidity ^0.8.0;

contract takeprofit is orderSystem{
uint constant fee = 4;

uint public test;
uint public testi;
uint public testii;


function take(bool up) public {
if(up == true){
    uint i = 0;
    while (i<id){
        i++;
        address payable addr = payable(idBase[i]);
        uint coef = bidIds[i];
        testii = coef;
        uint val = filledBids[i][coef];
        testi = val+testi;
        test = test + (val*(coef/1000+1)*(100-fee)/100);
        addr.transfer(val*(coef/1000+1)*(100-fee)/100);  
    }
}

else{
    uint i = 0;
    while (i<id){
        i++;
        address payable addr = payable(idBase[i]);
        uint coef = askIds[i];
        uint val = filledAsks[i][coef];
        addr.transfer(val*(coef/1000+1)*(100-fee)/100);
    }
}

}
}
