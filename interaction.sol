// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./token.sol";

contract TokenContract {
    // Адрес владельца контракта
    address public owner;

    //MTs per 1 BNB
    uint public price = 6000;

    // Адрес токен-контракта
    address public tokenContractAddress;

    // Событие для отслеживания транзакций
    event Withdrawal(address indexed owner, uint256 value);

    // Модификатор, который ограничивает вызов функций только владельцем
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // Конструктор, принимающий адрес токен-контракта и устанавливающий владельца
    constructor() {
        tokenContractAddress = 0xF788cB676B8D35f7b4f724FEb93F832ec5f18DF7 ;
        owner = msg.sender;
    }

    //VIP уровни
    uint[6] vips_mt = [0, 200, 800, 4000, 20000, 100000];
    uint[6] vips_fee = [40, 30, 15, 5, 1, 0]; //0.1% x

    // Функция для изменения владельца контракта
    function changeOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    // Функция для выполнения вывода токенов
    function withdrawMT(uint256 value, address addr) internal {
        // Инстанцируем интерфейс ERC-20
        IERC20 tokenContract = IERC20(tokenContractAddress);

        // Выполняем отправку токенов
        require(tokenContract.transfer(addr, value), "Token transfer failed");

        // Отправляем событие для отслеживания транзакции
        emit Withdrawal(addr, value);
    }

    function withdrawBNB() public onlyOwner {
        address payable _owner = payable(owner);
        _owner.transfer(address(this).balance);
    }

    function tradeToken() public payable{
        IBEP20 tokenContract = IBEP20(tokenContractAddress);
        uint value = msg.value * price;
        uint bal = tokenContract.balanceOf(address(this));

        if(bal<=value){
        withdrawMT(bal, msg.sender);}

        else{withdrawMT(value, msg.sender);}
    }

    function vip() public view returns(uint, uint){
        IBEP20 tokenContract = IBEP20(tokenContractAddress);
        uint bal = tokenContract.balanceOf(msg.sender);
        uint myvip;
        while(myvip<=4){
            if(bal >= vips_mt[myvip+1] * 10**18){
                myvip++;
            }
            else{break;}
        }

        return(bal, vips_fee[myvip]);
    }
}

