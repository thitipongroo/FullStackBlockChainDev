//SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.8.17;

contract SimpleBank {
    mapping(address => uint256) public balance;
    bool entry = false;

    function deposit() public payable {
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
