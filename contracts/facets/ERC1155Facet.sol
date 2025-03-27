// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC1155} from "../interfaces/IERC1155.sol";
import {AppStorage} from "../libraries/AppStorage.sol";
import {IStakingFacet} from "../interfaces/IStakingFacet.sol";
import {IERC20} from "../interfaces/IERC20.sol";

/// @title ERC1155Facet
/// @notice This contract allows users to stake and withdraw ERC1155 tokens.
///         It implements the staking logic for ERC1155 tokens within the diamond contract.
/// @dev The contract interacts with the AppStorage to track staking records and total staked tokens.
abstract contract ERC1155Facet is IStakingFacet {

    // Track users who have staked ERC1155 tokens
    address[] public users;
    mapping(address => bool) public userExists;

    // The ERC20 reward token used to reward users
    IERC20 public rewardToken;

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

        // Add user to the list if they haven't staked before
        if (!userExists[msg.sender]) {
            users.push(msg.sender);
            userExists[msg.sender] = true;
        }
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

    /// @notice Distribute rewards to users based on their staked ERC1155 tokens
    /// @dev This function iterates over all users and distributes rewards accordingly.
    function distributeRewards(address token) external {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Iterate over all users who have staked ERC1155 tokens
        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];

            uint256 erc1155Reward = 0;

            // Iterate over all tokenIds for this user and calculate the total rewards
            for (uint256 tokenId = 0; tokenId < 10000; tokenId++) { // Assuming tokenId range is from 0 to 9999
                uint256 stakedAmount = s.stakesERC1155[user][token][tokenId];
                if (stakedAmount > 0) {
                    erc1155Reward += stakedAmount;
                }
            }

            // Reward the user with the calculated amount
            rewardUser(user, erc1155Reward);
        }
    }

    /// @notice Reward a user with the calculated ERC1155 reward amount
    /// @dev This function handles the logic to distribute the actual rewards to the user
    function rewardUser(address user, uint256 rewardAmount) internal {
        // Implement the reward distribution logic (e.g., transfer ERC20 or ERC1155 tokens)
        // Example: Transfer ERC20 tokens as rewards
        rewardToken.transfer(user, rewardAmount);
    }

    // Abstract methods for ERC20 and ERC721 that must be implemented in derived contracts
    function stakeERC20(address token, uint256 amount) external virtual override;
    function withdrawERC20(address token, uint256 amount) external virtual override;
    function stakeERC721(address token, uint256 tokenId) external virtual override;
    function withdrawERC721(address token, uint256 tokenId) external virtual override;

    // A function to return the list of users who have staked ERC1155 tokens
    function getAllUsers() external view returns (address[] memory) {
        return users;
    }

    // Set the reward token (ERC20 token) used for distributing rewards
    function setRewardToken(address _rewardToken) external {
        rewardToken = IERC20(_rewardToken);
    }
}
