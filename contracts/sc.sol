pragma solidity ^0.4.0;
import "./owned.sol";


// contract Sc is Token, Owned {
contract Sc is Owned {
    
    uint256 public price = 2;              // Цена за токен
    uint public factorMinDistribution = 3; // коофициент минимума к выводу
    uint public factorMinPurchase = 1;     // минимально к покупке умножено на цену
    uint public lastDateDistribution = 0;  // таймстамп последнего распределения
    uint public delayDistribution = 100;   // максимальное время холда
    
    function minPurchase() view public returns(uint) {
        return(price * factorMinPurchase);
    }
    
    function minDistribution() view public returns(uint) {
        return (price * factorMinDistribution);
    }
    
    function timeIsUp() view public returns(bool) {
        if (block.timestamp > (lastDateDistribution + delayDistribution) && address(this).balance >= (minDistribution() / 2)) {
            return(true);
        } else {
            return(false);
        }
    }
    
    function isBalanceOverflow() view public returns(bool) {
        if (address(this).balance >= minDistribution()) {
            return true;
        } else {
            return false;
        }
    }
    
    
    
    function setFactors(uint _price, uint _md, uint _mp, uint _dd) public onlyOwner {
        require(_price > 0 && _md > 0 && _mp > 0);
        price = _price;
        factorMinPurchase = _mp;
        factorMinDistribution = _md;
        delayDistribution = _dd;
    }
    
    
    function contractBalance() view public returns(uint) {
        return address(this).balance;
    }
    
    
}