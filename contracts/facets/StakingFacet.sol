// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IStakingFacet} from "../interfaces/IStakingFacet.sol";
import {AppStorage} from "../libraries/AppStorage.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {IERC721} from "../interfaces/IERC721.sol";
import {IERC1155} from "../interfaces/IERC1155.sol";

/// @title StakingFacet
/// @notice This contract allows users to stake and withdraw ERC20, ERC721, and ERC1155 tokens.
///         It includes an initialization function to set the reward rate and manages user stakes.
contract StakingFacet is IStakingFacet {
    /// @notice Initializes the contract with an initial reward rate
    /// @dev This function is called to set the initial reward rate when the contract is deployed
    /// @param _rewardRate The initial reward rate to set
    function initialize(uint256 _rewardRate) public {
        AppStorage.Storage storage s = AppStorage.getStorage();
        s.rewardRate = _rewardRate; // Set initial reward rate
    }

    /// @notice Stake ERC20 tokens into the contract
    /// @dev Transfers ERC20 tokens from the sender to the contract and updates the user's staking balance
    /// @param token The address of the ERC20 token to stake
    /// @param amount The amount of the ERC20 token to stake
    function stakeERC20(address token, uint256 amount) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Transfer ERC20 tokens from the sender to the contract
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Transfer failed");

        // Update the staking balance for the user
        s.stakesERC20[msg.sender] += amount;
        s.totalStakedERC20 += amount;
    }

    /// @notice Withdraw ERC20 tokens from the contract
    /// @dev Transfers ERC20 tokens from the contract back to the user's address and updates the user's staking balance
    /// @param token The address of the ERC20 token to withdraw
    /// @param amount The amount of the ERC20 token to withdraw
    function withdrawERC20(address token, uint256 amount) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();
        require(s.stakesERC20[msg.sender] >= amount, "Insufficient balance");

        // Transfer the ERC20 tokens back to the user
        require(IERC20(token).transfer(msg.sender, amount), "Transfer failed");

        // Update the staking balance for the user
        s.stakesERC20[msg.sender] -= amount;
        s.totalStakedERC20 -= amount;
    }

    /// @notice Stake ERC721 tokens into the contract
    /// @dev Transfers the specified ERC721 token from the sender to the contract and updates the user's staking record
    /// @param token The address of the ERC721 token to stake
    /// @param tokenId The ID of the ERC721 token to stake
    function stakeERC721(address token, uint256 tokenId) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Transfer ERC721 token from the sender to the contract
        IERC721(token).safeTransferFrom(msg.sender, address(this), tokenId);

        // Update the staking record for the user
        s.stakesERC721[msg.sender][tokenId] = 1; 
        s.totalStakedERC721 += 1;
    }

    /// @notice Withdraw ERC721 tokens from the contract
    /// @dev Transfers the specified ERC721 token from the contract back to the user's address and updates the user's staking record
    /// @param token The address of the ERC721 token to withdraw
    /// @param tokenId The ID of the ERC721 token to withdraw
    function withdrawERC721(address token, uint256 tokenId) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();
        require(s.stakesERC721[msg.sender][tokenId] > 0, "Not staked");

        // Transfer the ERC721 token back to the user
        IERC721(token).safeTransferFrom(address(this), msg.sender, tokenId);

        // Update the staking record for the user
        s.stakesERC721[msg.sender][tokenId] = 0;
        s.totalStakedERC721 -= 1;
    }

    /// @notice Stake ERC1155 tokens into the contract
    /// @dev Transfers the specified amount of ERC1155 tokens from the sender to the contract and updates the user's staking record
    /// @param token The address of the ERC1155 token to stake
    /// @param tokenId The ID of the ERC1155 token to stake
    /// @param amount The amount of the ERC1155 token to stake
    function stakeERC1155(address token, uint256 tokenId, uint256 amount) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Transfer ERC1155 token from the sender to the contract
        IERC1155(token).safeTransferFrom(msg.sender, address(this), tokenId, amount, "");

        // Update the staking record for the user
        s.stakesERC1155[msg.sender][tokenId] += amount;
        s.totalStakedERC1155 += amount;
    }

    /// @notice Withdraw ERC1155 tokens from the contract
    /// @dev Transfers the specified amount of ERC1155 tokens from the contract back to the user's address and updates the user's staking record
    /// @param token The address of the ERC1155 token to withdraw
    /// @param tokenId The ID of the ERC1155 token to withdraw
    /// @param amount The amount of the ERC1155 token to withdraw
    function withdrawERC1155(address token, uint256 tokenId, uint256 amount) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();
        require(s.stakesERC1155[msg.sender][tokenId] >= amount, "Insufficient balance");

        // Transfer ERC1155 tokens back to the user
        IERC1155(token).safeTransferFrom(address(this), msg.sender, tokenId, amount, "");

        // Update the staking record for the user
        s.stakesERC1155[msg.sender][tokenId] -= amount;
        s.totalStakedERC1155 -= amount;
    }
}
