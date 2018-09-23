pragma solidity ^0.4.0;
import "./owned.sol";
import "./forEach.sol";

contract Token is Owned, ForEach {

    mapping (address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    

    string public name = "Blockchain hipe";
    string public symbol = "HIPE";

    uint256 public totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor(string _name, string _symbol) public {
        name = _name;
        symbol = _symbol;
    }
    
    function setAccounts(address from, address to) private {
        if (from != 0x0 && balanceOf[from] == 0) {
            remove(from);
        }
        if (!inList(to)) {
            push(to);
        }
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value);

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        setAccounts(msg.sender, to);
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
        setAccounts(from, to);
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
    
    function chargeTokens(address to, uint val) public onlyOwner {
        require(val > 0);
        
        totalSupply += val;
        balanceOf[to] += val;
        setAccounts(0x0, to);
        emit Transfer(address(this), to, val);
    }
    
}
