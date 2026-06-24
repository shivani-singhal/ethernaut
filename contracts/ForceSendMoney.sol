// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceSend{ 
    mapping(address => uint256) public contributions;
    address public owner;
    address payable recipient;
    constructor(address payable _recipient) {
        owner = msg.sender;
        recipient = _recipient;
    }

    function destruct() external payable {
        selfdestruct(recipient);
    }
}