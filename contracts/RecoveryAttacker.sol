// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AddressPredictor {
    function predictAddress(address factory, uint256 nonce) external pure returns (address) {
        bytes memory data;
        if (nonce == 0) {
            data = abi.encodePacked(bytes1(0xd6), bytes1(0x94), factory, bytes1(0x80));
        } else if (nonce < 0x80) {
            data = abi.encodePacked(bytes1(0xd6), bytes1(0x94), factory, uint8(nonce));
        } else if (nonce <= 0xff) {
            data = abi.encodePacked(bytes1(0xd7), bytes1(0x94), factory, bytes1(0x81), uint8(nonce));
        } else if (nonce <= 0xffff) {
            data = abi.encodePacked(bytes1(0xd8), bytes1(0x94), factory, bytes1(0x82), uint16(nonce));
        } else {
            // Fallback for extremely high nonces
            revert("Nonce too high for simple wrapper");
        }
        return address(uint160(uint256(keccak256(data))));
    }
}
