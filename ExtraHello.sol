// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "./HelloWorld.sol";

contract ExtraHello is HelloWorld {
    function setMessage(string memory _message) public override {
        message = string.concat(_message, "_1");
    }
}
