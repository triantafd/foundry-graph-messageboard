// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MessageBoard {
    event NewMessage(address indexed sender, string message, uint256 timestamp);

    function postMessage(string calldata message) external {
        emit NewMessage(msg.sender, message, block.timestamp);
    }
}
