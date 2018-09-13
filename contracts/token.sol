pragma solidity ^0.4.0;

contract Token {

    mapping (address => uint256) public balanceOf;
    mapping (address => bool) hasHistory;
    address[] accounts;
    mapping(address => mapping(address => uint256)) public allowance;

    string constant name = "Blockchain hipe";
    string constant symbol = "HIPE";

    uint256 public totalSupply = 10;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor() public {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    function setAccounts(address to) private {
        if (!hasHistory[to]) {
            hasHistory[to] = true;
            accounts.push(to);
        }
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value);

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        setAccounts(to);
        emit Transfer(msg.sender, to, value);
        return true;
    }



    function approve(address spender, uint256 value) public returns (bool success) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);

        balanceOf[from] -= value;
        balanceOf[to] += value;
        setAccounts(to);
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
    
    function chargeTokens(address to, uint val) internal returns(bool) {
        if (val <= 0) {
            return false;
        }
        
        totalSupply += val;
        balanceOf[to] += val;
        setAccounts(to);
        emit Transfer(address(this), to, val);
        return true;
    }
    
    function myBalance() view public returns(uint) {
        return balanceOf[msg.sender];
    }
}
