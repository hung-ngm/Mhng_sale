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

  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _value
  );
  
  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;
  
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

  // Delegated Transfer
  //Approve

  function approve(address _spender, uint256 _value) public returns (bool success) {
    allowance[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);

    return true;
  }

  // TranferFrom
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(_value <= balanceOf[_from]);
    require(_value <= allowance[_from][msg.sender]);
    
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;

    allowance[_from][msg.sender] -= _value;
    
    emit Transfer(_from, _to, _value);
    return true;
  }

}