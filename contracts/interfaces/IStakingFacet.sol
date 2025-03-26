// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStakingFacet {
    /// @notice Stake ERC20 tokens into the contract
    /// @dev This function allows users to stake a specified amount of ERC20 tokens into the contract.
    /// @param token The address of the ERC20 token to stake
    /// @param amount The amount of ERC20 tokens to stake
    function stakeERC20(address token, uint256 amount) external;

    /// @notice Withdraw ERC20 tokens from the contract
    /// @dev This function allows users to withdraw a specified amount of ERC20 tokens that they previously staked.
    /// @param token The address of the ERC20 token to withdraw
    /// @param amount The amount of ERC20 tokens to withdraw
    function withdrawERC20(address token, uint256 amount) external;

    /// @notice Stake ERC721 tokens into the contract
    /// @dev This function allows users to stake an ERC721 token by specifying the token ID.
    /// @param token The address of the ERC721 token to stake
    /// @param tokenId The ID of the ERC721 token to stake
    function stakeERC721(address token, uint256 tokenId) external;

    /// @notice Withdraw ERC721 tokens from the contract
    /// @dev This function allows users to withdraw an ERC721 token by specifying the token ID.
    /// @param token The address of the ERC721 token to withdraw
    /// @param tokenId The ID of the ERC721 token to withdraw
    function withdrawERC721(address token, uint256 tokenId) external;

    /// @notice Stake ERC1155 tokens into the contract
    /// @dev This function allows users to stake ERC1155 tokens by specifying the token ID and the amount.
    /// @param token The address of the ERC1155 token to stake
    /// @param tokenId The ID of the ERC1155 token to stake
    /// @param amount The amount of ERC1155 tokens to stake
    function stakeERC1155(address token, uint256 tokenId, uint256 amount) external;

    /// @notice Withdraw ERC1155 tokens from the contract
    /// @dev This function allows users to withdraw ERC1155 tokens by specifying the token ID and amount.
    /// @param token The address of the ERC1155 token to withdraw
    /// @param tokenId The ID of the ERC1155 token to withdraw
    /// @param amount The amount of ERC1155 tokens to withdraw
    function withdrawERC1155(address token, uint256 tokenId, uint256 amount) external;
}
