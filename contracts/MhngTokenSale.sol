pragma solidity >=0.5.16;

import "./MhngToken.sol";

contract MhngTokenSale {
  address payable admin;
  MhngToken public tokenContract;
  uint256 public tokenPrice;
  uint256 public tokensSold;

  event Sell(
    address _buyer,
    uint256 _amount
  );

  constructor(MhngToken _tokenContract, uint256 _tokenPrice) public {
    admin = msg.sender;
    tokenContract = _tokenContract;
    tokenPrice = _tokenPrice;
  }

  // Multiply
  function multiply(uint x, uint y) internal pure returns (uint z) {
    require(y == 0 || (z = x*y)/y == x);
  }
  
  // Buy Tokens
  function buyTokens(uint256 _numberOfTokens) public payable {
    require(msg.value == multiply(_numberOfTokens, tokenPrice));
    require(address(tokenContract).balance >= _numberOfTokens);
    require(tokenContract.transfer(msg.sender, _numberOfTokens));

    tokensSold += _numberOfTokens;

    emit Sell(msg.sender, _numberOfTokens);
  }

  // Ending Token MHNG Token sale
  function endSale() public {
    // Require admin
    require(msg.sender == admin);

    // Transfer remaining Mhng Tokens to admin
    require(tokenContract.transfer(admin, address(tokenContract).balance));

    // Destroy contract
    selfdestruct(admin);

  }
}