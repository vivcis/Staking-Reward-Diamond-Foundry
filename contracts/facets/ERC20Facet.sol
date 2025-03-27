// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "../interfaces/IERC20.sol";
import {AppStorage} from "../libraries/AppStorage.sol";
import {IStakingFacet} from "../interfaces/IStakingFacet.sol";

/// @title ERC20RewardFacet
/// @notice This contract allows users to stake, withdraw, and claim rewards from ERC20 tokens.
///         It also distributes rewards based on the total amount of tokens staked (ERC20, ERC721, ERC1155).
/// @dev This contract interacts with the AppStorage to store information about staking and rewards.
abstract contract ERC20Facet is IStakingFacet {

    // Track users who have staked ERC20, ERC721, or ERC1155 tokens
    address[] public users;

    /// @notice Stake ERC20 tokens into the contract
    /// @dev Transfers ERC20 tokens from the user's address to the contract and updates the staking record
    /// @param token The address of the ERC20 token being staked
    /// @param amount The amount of the ERC20 token to stake
    function stakeERC20(address token, uint256 amount) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Transfer ERC20 token to contract
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        // Update staking record
        s.stakesERC20[msg.sender] += amount;

        // Update total staked ERC20 tokens
        s.totalStakedERC20 += amount;

        // Add user to the list if they haven't staked before
        if (s.stakesERC20[msg.sender] == amount) {
            users.push(msg.sender);
        }
    }

    /// @notice Withdraw ERC20 tokens from the contract
    /// @dev Transfers ERC20 tokens from the contract back to the user's address and updates the staking record
    /// @param token The address of the ERC20 token being withdrawn
    /// @param amount The amount of the ERC20 token to withdraw
    function withdrawERC20(address token, uint256 amount) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();

        require(s.stakesERC20[msg.sender] >= amount, "Insufficient balance");

        // Transfer ERC20 tokens back to the user
        IERC20(token).transfer(msg.sender, amount);

        // Update staking record
        s.stakesERC20[msg.sender] -= amount;

        // Update total staked ERC20 tokens
        s.totalStakedERC20 -= amount;
    }

    /// @notice Distribute rewards to users based on their total stake
    /// @dev This function calculates the total rewards based on the staking of ERC20, ERC721, and ERC1155 tokens
    ///      and updates the reward per stake.
    /// @param rewardToken The address of the reward token that will be distributed
    function distributeRewards(address rewardToken) external  {
        AppStorage.Storage storage s = AppStorage.getStorage();

        uint256 totalStakedERC20 = s.totalStakedERC20;
        uint256 totalStakedERC721 = 0;
        uint256 totalStakedERC1155 = 0;

        // Calculate total staked ERC721 and ERC1155 tokens for all users
        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];

            // ERC721: Loop through tokenIds (assuming a max of 10000 tokenIds)
            for (uint256 tokenId = 0; tokenId < 10000; tokenId++) {
                totalStakedERC721 += s.stakesERC721[user][tokenId];
            }

            // ERC1155: Loop through tokenIds (assuming a max of 10000 tokenIds)
            for (uint256 tokenId = 0; tokenId < 10000; tokenId++) {
                totalStakedERC1155 += s.stakesERC1155[user][tokenId];
            }
        }

        uint256 totalStaked = totalStakedERC20 + totalStakedERC721 + totalStakedERC1155;
        require(totalStaked > 0, "No tokens staked");

        uint256 rewardAmount = s.rewardRate * totalStaked;

        // Transfer reward token from sender to this contract
        require(IERC20(rewardToken).transferFrom(msg.sender, address(this), rewardAmount), "Transfer failed");

        // Update reward per stake
        s.rewardPerStake += rewardAmount / totalStaked;
    }

    /// @notice Claim rewards based on the user's staked tokens
    /// @dev The function calculates the rewards for ERC20, ERC721, and ERC1155 staked tokens and sends them to the user
    /// @param rewardToken The address of the reward token that will be transferred to the user
    function claimRewards(address rewardToken) external  {
        AppStorage.Storage storage s = AppStorage.getStorage();
        uint256 reward = s.rewardPerStake * s.stakesERC20[msg.sender];

        // Add the rewards from ERC721 and ERC1155 stakes
        uint256 erc721Reward = 0;
        uint256 erc1155Reward = 0;

        // Calculate ERC721 rewards (assuming tokenId range from 0 to 9999)
        for (uint256 tokenId = 0; tokenId < 10000; tokenId++) {
            erc721Reward += s.stakesERC721[msg.sender][tokenId];
        }

        // Calculate ERC1155 rewards (assuming tokenId range from 0 to 9999)
        for (uint256 tokenId = 0; tokenId < 10000; tokenId++) {
            erc1155Reward += s.stakesERC1155[msg.sender][tokenId];
        }

        // Add rewards from ERC721 and ERC1155 tokens
        reward += (s.rewardPerStake * erc721Reward) + (s.rewardPerStake * erc1155Reward);

        // Transfer the accumulated reward to the staker
        require(IERC20(rewardToken).transfer(msg.sender, reward), "Transfer failed");
    }
}
