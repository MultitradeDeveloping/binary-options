// import "./strings.sol";
// SPDX-License-Identifier: MIT
import "./fillorders.sol";
pragma solidity ^0.8.0;




contract takeprofit is orderSystem{
uint constant fee = 4;

function take(bool up) internal{
if(up == true){
    uint i = 0;
    while (i<id){
        i++;
        address payable addr = payable(idBase[i]);
        uint coef = bidIds[i];
        uint val = filledBids[i][coef];
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
