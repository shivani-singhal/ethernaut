// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDetectionBot {
    function handleTransaction(address user, bytes calldata msgData) external;
}

interface IForta {
    function raiseAlert(address user) external;
}

contract Detection is IDetectionBot{
    address public cryptoVault;
    address public fortaAddress;
    address private origSender;

    constructor(address _cryptoVault, address _fortaAddress) {
        cryptoVault = _cryptoVault;
        fortaAddress = _fortaAddress;
    }
    function handleTransaction(address user, bytes calldata msgData) external {
        (, , address _origSender) = abi.decode(msgData[4:], (address, address, address));
        origSender = _origSender;
        if (_origSender == cryptoVault) {
            IForta(fortaAddress).raiseAlert(user);
        }
    }
}

