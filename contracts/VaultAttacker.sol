// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VaultAttacker {
    
    function pay(address _to) public payable{

         (bool success, ) = _to.call{value: msg.value}("");
        
        // 3. Always check if the external call succeeded
        require(success, "Failed to send Ether to King contract");
    }
}
