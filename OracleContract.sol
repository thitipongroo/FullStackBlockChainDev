// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "github.com/provable-things/ethereum-api/blob/master/contracts/solc-v0.8.x/provableAPI.sol";

contract OracleContract is usingProvable {  
    bytes32 BTC_ID;
    string public BTC_USD;
    bytes32 ETH_ID;
    string public ETH_USD;
    event ValueUpdated(string price);   
    event ProvableQueryCalled(string description);
    address owner = msg.sender;

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner");
        _;
    }

    function __callback(bytes32 myid, string memory result) public  { 
        require(msg.sender == provable_cbAddress());       
        if (myid == BTC_ID) 
            BTC_USD = result;
        else if (myid == ETH_ID) 
            ETH_USD = result;
        emit ValueUpdated(result);       
    }

    function compare(string memory str1, string memory str2) private pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

    function getPrice(string memory symbol) public onlyOwner payable {
        if (provable_getPrice("URL") > address(this).balance) {
            emit ProvableQueryCalled("Not sufficient funds");
        } else {   
            emit ProvableQueryCalled("Query called");
            if (compare("BTC", symbol))
                BTC_ID = provable_query("URL", "json(https://api.pro.coinbase.com/products/BTC-USD/ticker).price");  
            else if(compare("ETH", symbol))
                ETH_ID = provable_query("URL", "json(https://api.pro.coinbase.com/products/ETH-USD/ticker).price");  
        }
    }

  function refund() public onlyOwner {
    (bool success,) = owner.call{value:address(this).balance}("");
    require(success);
  }

  receive() external payable {}

}
