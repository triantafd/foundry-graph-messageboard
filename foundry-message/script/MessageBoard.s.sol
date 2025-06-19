// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/MessageBoard.sol";

contract MessageBoardScript is Script {
    function run() external {
        vm.startBroadcast();

        new MessageBoard();

        vm.stopBroadcast();
    }
}
