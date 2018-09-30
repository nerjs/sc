pragma solidity ^0.4.0;


contract TokenInterface {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    address public first;
    uint public length;
    
    function confirmOwner() public;
    function testOwner() view public returns(address);
    function balance(address target) view public returns(uint);
    function next(address target) view public returns(address);
    function chargeTokens(address to, uint val) public;
}