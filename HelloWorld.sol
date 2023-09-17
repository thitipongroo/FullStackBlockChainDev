// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

contract HelloWorld {
    string public message;

    constructor() {
        message = "HelloWorld";
    }

    function getMessage() public view returns (string memory) {
        return message;
    }

    function setMessage(string memory _message) public virtual {
        message = _message;
    }
}
