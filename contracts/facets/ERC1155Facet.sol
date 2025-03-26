// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC1155} from "../interfaces/IERC1155.sol";
import {AppStorage} from "../libraries/AppStorage.sol";
import {IStakingFacet} from "../interfaces/IStakingFacet.sol";

/// @title ERC1155Facet
/// @notice This contract allows users to stake and withdraw ERC1155 tokens.
///         It implements the staking logic for ERC1155 tokens within the diamond contract.
/// @dev The contract interacts with the AppStorage to track staking records and total staked tokens.
abstract contract ERC1155Facet is IStakingFacet {
    /// @notice Stake ERC1155 tokens into the contract
    /// @dev Transfers the specified ERC1155 token from the user's address to the contract's address
    ///      and updates the staking record for the user.
    /// @param token The address of the ERC1155 token to stake
    /// @param tokenId The ID of the ERC1155 token to stake
    /// @param amount The amount of the ERC1155 token to stake
    function stakeERC1155(address token, uint256 tokenId, uint256 amount) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Transfer ERC1155 token to contract
        IERC1155(token).safeTransferFrom(msg.sender, address(this), tokenId, amount, "");

        // Update staking record for the user
        s.stakesERC1155[msg.sender][token][tokenId] += amount;

        // Update total staked ERC1155 tokens for the specific tokenId
        s.totalStakedERC1155[token][tokenId] += amount;
    }

    /// @notice Withdraw ERC1155 tokens from the contract
    /// @dev Transfers the specified ERC1155 token from the contract back to the user's address
    ///      and clears the staking record for the user.
    /// @param token The address of the ERC1155 token to withdraw
    /// @param tokenId The ID of the ERC1155 token to withdraw
    /// @param amount The amount of the ERC1155 token to withdraw
    function withdrawERC1155(address token, uint256 tokenId, uint256 amount) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Ensure the user has staked enough ERC1155 tokens
        require(s.stakesERC1155[msg.sender][token][tokenId] >= amount, "Insufficient staked amount");

        // Transfer ERC1155 token back to the user
        IERC1155(token).safeTransferFrom(address(this), msg.sender, tokenId, amount, "");

        // Update staking record for the user
        s.stakesERC1155[msg.sender][token][tokenId] -= amount;

        // Update total staked ERC1155 tokens for the specific tokenId
        s.totalStakedERC1155[token][tokenId] -= amount;
    }

    // Example of iteration over all users in `stakesERC1155` and handling their rewards
    function distributeRewards(address token) external {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Iterate over all users (note: you need to have a list of users, this is an example)
        // Here I'm assuming you have a list of users stored in an array or another method
        for (uint256 i = 0; i < someListOfUsers.length; i++) {
            address user = someListOfUsers[i]; // You need to define or maintain this list of users

            // Calculate rewards based on user's stake
            uint256 erc1155Reward = 0;

            // Iterate over all tokenId for this user
            for (uint256 tokenId = 0; tokenId < s.totalStakedERC1155[token][tokenId]; tokenId++) {
                erc1155Reward += s.stakesERC1155[user][token][tokenId];
            }

            // Do something with the rewards, for example, distribute them
            // rewardUser(user, erc1155Reward);  // Add your reward distribution logic
        }
    }

    // Abstract methods for ERC20 and ERC721 that must be implemented in derived contracts
    function stakeERC20(address token, uint256 amount) external virtual override;
    function withdrawERC20(address token, uint256 amount) external virtual override;
    function stakeERC721(address token, uint256 tokenId) external virtual override;
    function withdrawERC721(address token, uint256 tokenId) external virtual override;
}
