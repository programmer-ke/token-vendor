pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 _tokensToTransfer = tokensPerEth * msg.value;
    bool sent = yourToken.transfer(msg.sender, _tokensToTransfer);
    require(sent, "FAILED TO TRANSFER TOKENS");

    emit BuyTokens(msg.sender, msg.value, _tokensToTransfer);
  }


  // create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    (bool sent,) = msg.sender.call{value: address(this).balance}("");
    require(sent, "FAILED TO SEND ETHER");
  }


  // create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public {
    bool sent = yourToken.transferFrom(msg.sender, address(this), _amount);
    require(sent, "FAILED TO TRANSFER TOKENS");
    uint256 _amountOfETH = _amount / tokensPerEth;
    (sent, ) = msg.sender.call{value: _amountOfETH}("");
    require(sent, "FAILED TO SEND ETHER");

    emit SellTokens(msg.sender, _amount, _amountOfETH);
  }
}
