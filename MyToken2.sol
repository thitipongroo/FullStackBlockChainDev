// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    uint256 unitsOneReiCanBuy = 10;

    event Buy(address indexed from, address indexed to, uint256 tokens);

    constructor() ERC20("MyToken", "MTK") {
        _mint(address(this), 1000000 * 10**decimals());
    }

    function buy() public payable {
        uint256 amount = msg.value * unitsOneReiCanBuy;
        _transfer(address(this), msg.sender, amount);
        emit Buy(address(this), msg.sender, amount);
    }
}
