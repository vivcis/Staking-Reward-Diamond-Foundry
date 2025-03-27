// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC721} from "../interfaces/IERC721.sol";
import {AppStorage} from "../libraries/AppStorage.sol";
import {IStakingFacet} from "../interfaces/IStakingFacet.sol";
import {IERC20} from "../interfaces/IERC20.sol";  // Add the import for IERC20

/// @title ERC721Facet
/// @notice This contract allows users to stake and withdraw ERC721 tokens.
///         It implements the staking logic for ERC721 tokens within the diamond contract.
/// @dev The contract interacts with the AppStorage to track staking records and total staked tokens.
abstract contract ERC721Facet is IStakingFacet {

    // Track users who have staked ERC721 tokens
    address[] public users;
    mapping(address => bool) public userExists;

    // Declare a variable for the reward token
    IERC20 public rewardToken;

    /// @notice Stake ERC721 tokens into the contract
    /// @dev Transfers the specified ERC721 token from the user's address to the contract's address
    ///      and updates the staking record for the user.
    /// @param token The address of the ERC721 token to stake
    /// @param tokenId The ID of the ERC721 token to stake
    function stakeERC721(address token, uint256 tokenId) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Transfer ERC721 token to contract
        IERC721(token).safeTransferFrom(msg.sender, address(this), tokenId);

        // Update staking record for the user
        s.stakesERC721[msg.sender][token][tokenId] += 1;

        // Add user to the list if they haven't staked before
        if (!userExists[msg.sender]) {
            users.push(msg.sender);
            userExists[msg.sender] = true;
        }
    }

    /// @notice Withdraw ERC721 tokens from the contract
    /// @dev Transfers the specified ERC721 token from the contract back to the user's address
    ///      and clears the staking record for the user.
    /// @param token The address of the ERC721 token to withdraw
    /// @param tokenId The ID of the ERC721 token to withdraw
    function withdrawERC721(address token, uint256 tokenId) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Ensure the user has staked enough ERC721 tokens
        require(s.stakesERC721[msg.sender][token][tokenId] > 0, "You haven't staked this token");

        // Transfer ERC721 token back to the user
        IERC721(token).safeTransferFrom(address(this), msg.sender, tokenId);

        // Update staking record for the user
        s.stakesERC721[msg.sender][token][tokenId] -= 1;
    }

    /// @notice Distribute rewards to users based on their staked ERC721 tokens
    /// @dev This function iterates over all users and distributes rewards accordingly.
    function distributeRewards(address token) external {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Iterate over all users who have staked ERC721 tokens
        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];

            uint256 erc721Reward = 0;

            // Calculate rewards for each user's staked ERC721 tokens
            for (uint256 tokenId = 0; tokenId < 10000; tokenId++) { // Assuming tokenId range is from 0 to 9999
                uint256 stakedAmount = s.stakesERC721[user][token][tokenId];
                if (stakedAmount > 0) {
                    erc721Reward += stakedAmount;
                }
            }

            // Reward the user with the calculated amount
            rewardUser(user, erc721Reward);
        }
    }

    /// @notice Reward a user with the calculated ERC721 reward amount
    /// @dev This function handles the logic to distribute the actual rewards to the user
    function rewardUser(address user, uint256 rewardAmount) internal {
        // Implement the reward distribution logic (e.g., transfer ERC20 tokens)
        rewardToken.transfer(user, rewardAmount);  // Transfer reward tokens to the user
    }

    // Abstract methods for ERC20 and ERC1155 that must be implemented in derived contracts
    function stakeERC20(address token, uint256 amount) external virtual override;
    function withdrawERC20(address token, uint256 amount) external virtual override;

    // A function to return the list of users who have staked ERC721 tokens
    function getAllUsers() external view returns (address[] memory) {
        return users;
    }

    // Set the reward token (ERC20 token) used for distributing rewards
    function setRewardToken(address _rewardToken) external {
        rewardToken = IERC20(_rewardToken);  // Set the reward token address
    }
}

