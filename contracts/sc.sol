pragma solidity ^0.4.0;
import "./token.sol";


contract Sc is Token1 {
    
    function contractBalance() view public returns(uint) {
        return address(this).balance;
    }
    
    function test() view public returns(uint) {
        return(block.timestamp);
    }
}
