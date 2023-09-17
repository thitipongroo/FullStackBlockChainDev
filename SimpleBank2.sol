// SPDX-License-Identifier: MIT
pragma solidity >=0.8.15;

contract SimpleBank {
    mapping(address => uint256) balances;
    address[] accounts;
    uint256 rate = 3;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        if (0 == balances[msg.sender]) {
            accounts.push(msg.sender);
        }
        balances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success);
    }

    function calculateInterest(address user, uint256 _rate)
        private
        view
        returns (uint256)
    {
        uint256 interest = (balances[user] * _rate) / 100;
        return interest;
    }

    function totalInterestPerYear() external view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < accounts.length; i++) {
            address account = accounts[i];
            uint256 interest = calculateInterest(account, rate);
            total = total + interest;
        }
        return total;
    }

    function payDividendsPerYear() public payable onlyOwner {
        uint256 totalInterest = 0;
        for (uint256 i = 0; i < accounts.length; i++) {
            address account = accounts[i];
            uint256 interest = calculateInterest(account, rate);
            balances[account] = balances[account] + interest;
            totalInterest = totalInterest + interest;
        }
        require(msg.value == totalInterest, "Not enough interest to pay!!");
    }

    function systemBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function systemDeposit() public payable onlyOwner returns (uint256) {
        return systemBalance();
    }

    function systemWithdraw(uint256 withdrawAmount)
        public
        onlyOwner
        returns (uint256)
    {
        require(
            systemBalance() >= withdrawAmount,
            "System balance is not enough"
        );
        (bool success, ) = msg.sender.call{value: withdrawAmount}("");
        require(success);
        return systemBalance();
    }
}
