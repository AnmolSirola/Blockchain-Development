// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract Lottery {
    address public manager;  // Address of the manager (deployer) of the contract
    address[] public players;  // Array to store the addresses of players
    address public winner;  // Address of the winner

    constructor() {
        manager = msg.sender;  // Set the manager as the deployer of the contract
    }

    function buyTicket() public payable {
        require(msg.value > 0.1 ether, "Minimum ticket price is 0.1 ether");  // Require a minimum ticket price of 0.1 ether
        players.push(msg.sender);  // Add the sender's address to the array of players
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));  // Generate a random number based on block difficulty, timestamp, and number of players
    }

    function selectWinner() public restricted {
        require(players.length > 0, "No players in the lottery");  // Require at least one player in the lottery

        uint256 index = random() % players.length;  // Generate a random index within the range of players
        address selectedPlayer = players[index];  // Get the address of the randomly selected player
        payable(selectedPlayer).transfer(address(this).balance);  // Transfer the contract's balance to the winner

        winner = selectedPlayer;  // Set the winner's address
        players = new address[](0);  // Reset the players array for the next round
    }

    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function");  // Require that only the manager can call this function
        _;  // Continue with the execution of the function
    }
}
