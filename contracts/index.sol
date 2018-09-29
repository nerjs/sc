pragma solidity ^0.4.0;
import "./owned.sol";
import "./token.sol";


contract Hipe is Owned {
    Token public token = new Token("Hipe Token","HPT");
    mapping (address => uint) public balanceEth;
    uint public price = 10 finney;
    
    // constructor(address _tok) public {
    //     Token _token = new Token("Hipe Token", "HPT");
    //     token = _token;
    // }
    
    function() payable public {
        require(msg.value >= price);
        require(msg.value > token.totalSupply());
        distribution(msg.value);
    }
    
    function distribution(uint value) public {
        uint ownerB = (value / 100) * 3;
        uint valueB = value - ownerB;
        balanceEth[owner] += ownerB;
        
        if (token.first() == 0x0) {
            balanceEth[owner] += valueB;
        } else {
            _distribution(valueB);
        }
        token.chargeTokens(msg.sender, (valueB / price));
    }
    
    function _distribution(uint value) private {
        uint v = value / token.totalSupply();
        uint t;
        uint i;
        address p = token.first();
        
        while (p != 0x0 && i < token.length()) {
            t = token.balance(p);
            balanceEth[p] += v*t;
            p = token.next(p);
            i += 1;
        }
    }
    
    function test() view public returns(address) {
        return owner;
    }
    
    function withdrawal() public {
        require(balanceEth[msg.sender] > 0);
        uint _bal = balanceEth[msg.sender];
        balanceEth[msg.sender] = 0;
        address(msg.sender).transfer(_bal);
    }
    
    
    
    function myBalance(bool typeBalance) view public returns(uint) {
        if (typeBalance) {
            return balanceEth[msg.sender];
        } else {
            return token.balance(msg.sender);
        }
    }
}