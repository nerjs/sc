pragma solidity ^0.4.0;
import "./sc.sol"; 

contract MyIndex is Sc {
    
    function() payable public {
        require(msg.value >= (factorMinPurchase * price));
        
        if (isBalanceOverflow() || timeIsUp()) {
            distribution();
        }
        
        purchase(msg.sender, msg.value);
    }
    

    
    function purchase(address to, uint val) public {
        chargeTokens(to, val / price);
    }
    
    function distribution() public {
        lastDateDistribution = block.timestamp + delayDistribution;
        owner.transfer(address(this).balance / 50);
        uint ethForToken = address(this).balance / totalSupply;
        
            
        
        address add;
        uint i;
        
        for (i = 0; i < accounts.length; i++) {
            add = accounts[i];
            add.transfer(balanceOf[add] * ethForToken);
        }
        
    }
}
