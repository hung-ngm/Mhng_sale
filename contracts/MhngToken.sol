pragma solidity ^0.5.16;

contract MhngToken {
  string public name = "MHNG Token";
  string public symbol = "MHNG";
  string public standard = "MHNG Token v1.0";
  uint256 public totalSupply;

  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 _value
  );
  
  mapping(address => uint256) public balanceOf;
  

  // Initialize the number of tokens available
  // Contructor
  constructor(uint256 _initialSupply) public {
    balanceOf[msg.sender] = _initialSupply;
    totalSupply = _initialSupply;     // state variables
  }
  
  // Transfer
  function transfer(address _to, uint256 _value) public returns (bool success) {
    require(balanceOf[msg.sender] >= _value);
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

}