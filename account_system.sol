// import "./strings.sol";
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ExternalContract {
    function marketbid_account() external;
    function marketask_account() external;
    function limitask_account() external;
    function limitbid_account() external;
}

contract accounts{
    
    address public main;
    address public owner_;

    mapping(bytes32 => uint) balances;

    constructor() {
        //main = 0x08739fDEBb111faEE923382708e2e9C6256EA707 ;
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

    function deposit(bytes32 pub) public payable{
        balances[pub] = balances[pub] + msg.value;
    }

    function withdraw(bytes32 pub, bytes32 priv, address addressee, uint value) public{
        if(checkPassword(pub, priv) == true){
            address payable addressee_ = payable(addressee);
            addressee_.transfer(value);
        }
    }
    
   }
