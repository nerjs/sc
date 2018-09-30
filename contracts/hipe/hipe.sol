pragma solidity ^0.4.0;
import "./distribution.sol";
import "./token_interface.sol";


contract Hipe is DistributionHipe {
   
   
    
    
    function() payable public {
        require(msg.value >= price);
        distribution(msg.value);
    }
    
    
    function reinvest(uint8 val) public hasTokenAddr {
        require(val >= 0 && val <= 10 && val != reinvestSchema[msg.sender]);
        TokenInterface token = TokenInterface(tokenAddr);
        require(token.balance(msg.sender) > 0);
        reinvestSchema[msg.sender] = val;
    }
    
    function withdrawal(uint8 ri) public hasTokenAddr {
        require(balanceEth[msg.sender] > 0);
        require(ri <= 10);
        uint _bal = balanceEth[msg.sender];
        balanceEth[msg.sender] = 0;
        if (ri > 0) {
            _bal = _reinvest(msg.sender, _bal, ri);
        }
        
        if (_bal > 0) {
            address(msg.sender).transfer(_bal);
        }
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