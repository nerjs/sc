pragma solidity ^0.4.0;
import "./owned.sol";
import "./token_interface.sol";


contract ControllHipe is Owned {
    address public tokenAddr;
    uint public price = 10 finney; 
    
    modifier hasTokenAddr () {
        require(tokenAddr != address(0), "has not tokenAddr");
        _;
    }
    
    function setPrice(uint _price) public onlyOwner {
        price = _price;
    }
    
    function setTokenKontract(address target) public onlyOwner returns(string) {
        TokenInterface token = TokenInterface(target);
        token.confirmOwner();
        address checkOwner = token.testOwner();
        if (checkOwner == address(this)) {
            tokenAddr = target;
        }
    }
    
}