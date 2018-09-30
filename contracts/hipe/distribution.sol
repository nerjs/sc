pragma solidity ^0.4.0;
import "./controll.sol";
import "./token_interface.sol";


contract DistributionHipe is ControllHipe {
    mapping (address => uint) public balanceEth;
    mapping (address => uint8) public reinvestSchema;
    uint public hold;
    
   
    
    
    
    function() payable public {
        require(msg.value >= price);
        distribution(msg.value);
    }
    
    function distribution(uint value) internal hasTokenAddr {
        TokenInterface token = TokenInterface(tokenAddr);
        require(value > token.totalSupply());
        value += hold;
        hold = 0;
        uint ownerB = (value / 100) * 3;
        uint valueB = value - ownerB;
        balanceEth[owner] += ownerB;
        
        if (token.first() == 0x0) {
            balanceEth[owner] += valueB;
        } else {
            
            uint v = valueB / token.totalSupply();
            uint i;
            address p = token.first();
            
            while (p != address(0) && i < token.length()) {
                _distribution(p, v * token.balance(p));
                p = token.next(p);
                i += 1;
            }
            
            
        }
        token.chargeTokens(msg.sender, (valueB / price));
    }
    
    function _distribution(address target, uint value) private {
        uint val = _reinvest(target, value, 0);
        if (val > 0) {
            balanceEth[target] += val;
        }
    }
    
    function _reinvest(address target, uint value, uint8 ri) internal hasTokenAddr returns(uint) {
        if (ri == 0) {
            ri = reinvestSchema[target];
        }
        if (ri == 0) return value;
        uint tk = (value / 10) * reinvestSchema[target];
        if ((tk / price) < 1) return value; 
        uint he = tk % price;
        tk = tk - he;
        TokenInterface token = TokenInterface(tokenAddr);
        token.chargeTokens(target, tk / price);
        hold += tk;
        return value - tk;
    }
    
    function test() pure public returns(uint) {
        return( 10%3);
    }
    
    function reinvest(uint8 val) public hasTokenAddr {
        require(val >= 0 && val <= 10 && val != reinvestSchema[msg.sender]);
        TokenInterface token = TokenInterface(tokenAddr);
        require(token.balance(msg.sender) > 0);
        reinvestSchema[msg.sender] = val;
    }
    
    function withdrawal() public hasTokenAddr {
        require(balanceEth[msg.sender] > 0);
        uint _bal = balanceEth[msg.sender];
        balanceEth[msg.sender] = 0;
        address(msg.sender).transfer(_bal);
    }
    
    
    
    
    function myBalance(bool typeBalance) view public hasTokenAddr returns(uint) {
        if (typeBalance) {
            return balanceEth[msg.sender];
        } else {
            TokenInterface token = TokenInterface(tokenAddr);
            return token.balance(msg.sender);
        }
    }
}