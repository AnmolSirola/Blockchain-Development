// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// A smart contract that promotes collaboration and incentivizes developers to contribute to the Lumos ecosystem

contract LumosContribution {
    mapping(address => uint256) public contributions;
    uint256 public totalContributions;

    event ContributionAdded(address indexed contributor, uint256 amount);

    function contribute() external payable {
        require(msg.value > 0, "Contribution amount must be greater than zero");
        
        // Store the contributor's contribution
        contributions[msg.sender] += msg.value;
        
        // Increase the total contributions
        totalContributions += msg.value;

        emit ContributionAdded(msg.sender, msg.value);
    }
    
    function withdraw() external {
        require(contributions[msg.sender] > 0, "No contributions to withdraw");
        
        uint256 amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        
        // Transfer the contribution amount to the contributor
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Failed to transfer funds");

        totalContributions -= amount;
    }
}
