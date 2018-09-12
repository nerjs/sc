pragma solidity ^0.4.0;

contract Owned {
    address owner;
    address newOwner;
    
    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    function transferOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    
    function confirmOwner() public {
        if (newOwner == msg.sender) {
            owner = msg.sender;
        }
    } 
    
    function testOwner() view public onlyOwner returns(address) {
        return(msg.sender);
    }
    
}
