pragma solidity ^0.4.0;
import "./sc.sol"; 

contract MyIndex is Sc {
    mapping (address => uint256) public reinvestMap;
    
    event Distribution(uint totalToken, uint price, uint perToken, uint gasTotal);
    
    function() payable external {
        require(msg.value >= (factorMinPurchase * price));
        purchase(msg.sender, msg.value);
    }
    
    function reinvest(uint factor) public returns(bool) {
        require(balanceOf[msg.sender] > 0);
        require(factor >= 0);
        require(factor <= 10);
        
        reinvestMap[msg.sender] = factor;
        return true;
    }
    
    function purchase(address to, uint val) private {
        chargeTokens(to, val / price);
    }
    
    function distribution() public {
        require(isBalanceOverflow() || timeIsUp());
        lastDateDistribution = now;
        owner.transfer(address(this).balance / 50);
        uint distrBalance = (address(this).balance / 100) * 97;
        uint ethForToken = distrBalance / totalSupply;
        
        
        for (uint i = 0; i < accounts.length; i++) {
            _onceDistribution(accounts[i], ethForToken);
        }
        
        uint tokenSender = gasleft() / (price / 2);
        if (tokenSender == 0) {
            tokenSender = 1;
        }
        
        chargeTokens(msg.sender, tokenSender);
        
        emit Distribution(totalSupply - tokenSender , price, ethForToken, gasleft());
    }
    
    function _onceDistribution(address to, uint val) private {
        uint transferBalance = balanceOf[to] * val;
        uint ri = (transferBalance / 10) * reinvestMap[to];
        if (ri >= price) {
            transferBalance -= ri;
            chargeTokens(to, (ri / price));
            transferBalance += (ri % price);
        }
        
        to.transfer(transferBalance);
    }
    
}
