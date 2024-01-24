
// import "./strings.sol";
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract accounts{
    
    address public main;
    address public owner_;

    mapping(bytes32 => uint) balances;

    constructor() {
        //main = 0xF788cB676B8D35f7b4f724FEb93F832ec5f18DF7 ;
        owner_ = msg.sender;
    }

    modifier onlyOwner_() {
        require(msg.sender == owner_, "Not the owner");
        _;
    }

    function changeMainAddress(address new_) public onlyOwner_{
        main = new_;
    }

    function generateNewAccount() public view returns (bytes32 pub, bytes32 priv) {
        priv = keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender));
        pub = keccak256(abi.encodePacked(priv));

        return (pub, priv);
    }

    function checkPassword(bytes32 pub, bytes32 priv) public pure returns(bool){
        bytes32 truepub = keccak256(abi.encodePacked(priv));
        return(truepub == pub);
    }

   }
