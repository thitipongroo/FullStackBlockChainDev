// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "./HelloWorld.sol";

contract HelloFactory is HelloWorld {
    HelloWorld[] public HWArray;

    function createHWContract() public {
        HelloWorld genHW = new HelloWorld();
        HWArray.push(genHW);
    }

    function hfGet(uint256 index) public view returns (string memory) {
        return HelloWorld(address(HWArray[index])).getMessage();
    }

    function hfSet(uint256 index, string memory _message) public {
        HelloWorld(address(HWArray[index])).setMessage(_message);
    }
}
