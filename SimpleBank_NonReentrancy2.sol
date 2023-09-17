//SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.8.17;

contract SimpleBank {
    mapping(address => uint256) public balance;
    bool entry = false;
    address[] accounts;
    uint256 rate = 3;
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner,"Not Authorized");
        _;
    }

    function deposit() public payable {
        if(balance[msg.sender] == 0){
            accounts.push(msg.sender);
        }
        balance[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public {
        require(!entry);
        entry = true;
        require(balance[msg.sender] >= amount);
        //วิธีที่ 1
        // payable(msg.sender).transfer(amount);
        
        //วิธีที่ 2
        (bool success,) = msg.sender.call{value: amount}("");
        require(success);

        balance[msg.sender] -= amount;

        entry = false;
    }

    function getBalance() public view returns(uint256){
        return balance[msg.sender];
    }

    function calculateInterest(address _user, uint256 _rate) private view returns(uint256){
        uint256 interest = balance[_user] * _rate / 100;
        return interest;
    }

    function totalInterestPerYear() public view returns(uint256){
        uint256 total = 0;
        for(uint256 i = 0; i < accounts.length; i++){
            address account = accounts[i];
            uint interest = calculateInterest(account, rate);
            total += interest;
        }
        return total;
    }

    function payDividendsPerYear() public payable onlyOwner{
        uint256 total = 0;
        for(uint256 i = 0; i < accounts.length; i++){
            address account = accounts[i];
            uint interest = calculateInterest(account, rate);
            total += interest;
            balance[account] += interest;
        }
        require(msg.value == total, "Not enough money to pay!!!");
    }

    function systemBalance() public view returns(uint256){
        return address(this).balance;
    }

    function systemDeposit() public onlyOwner payable returns (uint256) {
        return systemBalance();
    }

    function systemWithdraw(uint256 amount) public onlyOwner returns (uint256){
        require(systemBalance() >= amount,"System balance is not enough");
        (bool success,) = msg.sender.call{value: amount}("");
        require(success);
        return systemBalance();
    }
}

// underflow overflow
// uint8 -> 0 - 255
// uint8 a = 255
// uint8 b = 1
// uint8 c = a + b => 0
// uint8 d = 0 - 1 => 255
// safeMath build in solidity >= 0.8
// for {
//    unchecked {
//        balance[msg.sender] -= amount;
//    }
// }

// contract Hacker {
//     function attack(){
//         bank.deposit{value: 1 ether}();
//         bank.withdraw(1 ether);
//     }

//     receive() {
//         bank.withdraw(1 ether);
//     }
// }
