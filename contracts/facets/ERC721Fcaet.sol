// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC721} from "../interfaces/IERC721.sol";  
import {AppStorage} from "../libraries/AppStorage.sol";
import {IStakingFacet} from "../interfaces/IStakingFacet.sol";

/// @title ERC721Facet
/// @notice This contract allows users to stake and withdraw ERC721 tokens. 
///         It implements the staking logic for ERC721 tokens within the diamond contract.
/// @dev The contract interacts with the AppStorage to track staking records and total staked tokens.
abstract contract ERC721Facet is IStakingFacet {

    /// @notice Stake an ERC721 token into the contract
    /// @dev Transfers the specified ERC721 token from the user's address to the contract's address
    ///      and updates the staking record for the user.
    /// @param token The address of the ERC721 token to stake
    /// @param tokenId The ID of the ERC721 token to stake
    function stakeERC721(address token, uint256 tokenId) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Transfer ERC721 token to contract
        IERC721(token).transferFrom(msg.sender, address(this), tokenId);

        // Update staking record for the user
        s.stakesERC721[msg.sender][token][tokenId] += 1;

        // Update total staked ERC721 tokens for the specific tokenId
        s.totalStakedERC721[token] += 1;
    }

    /// @notice Withdraw an ERC721 token from the contract
    /// @dev Transfers the specified ERC721 token from the contract back to the user's address
    ///      and clears the staking record for the user.
    /// @param token The address of the ERC721 token to withdraw
    /// @param tokenId The ID of the ERC721 token to withdraw
    function withdrawERC721(address token, uint256 tokenId) external override {
        AppStorage.Storage storage s = AppStorage.getStorage();

        // Ensure the user has staked the given ERC721 token
        require(s.stakesERC721[msg.sender][token][tokenId] > 0, "You don't have this token staked");

        // Transfer ERC721 token back to the user
        IERC721(token).transferFrom(address(this), msg.sender, tokenId);

        // Clear staking record for the user
        s.stakesERC721[msg.sender][token][tokenId] -= 1;

        // Update total staked ERC721 tokens for the specific tokenId
        s.totalStakedERC721[token] -= 1;
    }

    // Abstract methods for ERC20 and ERC1155 that must be implemented in derived contracts

    /// @notice Stake ERC20 tokens into the contract
    /// @param token The address of the ERC20 token to stake
    /// @param amount The amount of ERC20 tokens to stake
    function stakeERC20(address token, uint256 amount) external virtual override;

    /// @notice Withdraw ERC20 tokens from the contract
    /// @param token The address of the ERC20 token to withdraw
    /// @param amount The amount of ERC20 tokens to withdraw
    function withdrawERC20(address token, uint256 amount) external virtual override;

    /// @notice Stake ERC1155 tokens into the contract
    /// @param token The address of the ERC1155 token to stake
    /// @param tokenId The ID of the ERC1155 token to stake
    /// @param amount The amount of ERC1155 tokens to stake
    function stakeERC1155(address token, uint256 tokenId, uint256 amount) external virtual override;

    /// @notice Withdraw ERC1155 tokens from the contract
    /// @param token The address of the ERC1155 token to withdraw
    /// @param tokenId The ID of the ERC1155 token to withdraw
    /// @param amount The amount of ERC1155 tokens to withdraw
    function withdrawERC1155(address token, uint256 tokenId, uint256 amount) external virtual override;
}
