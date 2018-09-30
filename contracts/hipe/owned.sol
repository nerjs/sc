pragma solidity ^0.4.0;

contract Owned {
    address owner;
    address newOwner;
    
    modifier onlyOwner() {
        require(owner == msg.sender, "only Owner");
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
    
    function testOwner() public view onlyOwner returns(address) {
        return(msg.sender);
    }
    
}
