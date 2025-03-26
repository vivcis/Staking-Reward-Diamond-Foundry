// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    /// @notice Returns the total supply of the token
    /// @dev This function provides the total number of tokens in circulation.
    /// @return totalSupply_ The total supply of the token
    function totalSupply() external view returns (uint256);

    /// @notice Returns the balance of a specific account
    /// @dev This function returns the amount of tokens owned by a specific address.
    /// @param account The address to query the balance of
    /// @return balance_ The token balance of the specified account
    function balanceOf(address account) external view returns (uint256);

    /// @notice Transfers a specified amount of tokens to a recipient
    /// @dev This function transfers tokens from the caller’s account to the recipient’s account.
    /// @param recipient The address to receive the tokens
    /// @param amount The amount of tokens to transfer
    /// @return success Returns true if the transfer is successful
    function transfer(address recipient, uint256 amount) external returns (bool);

    /// @notice Returns the allowance a spender has on an owner's tokens
    /// @dev This function returns the amount of tokens that a spender can spend from the owner’s account.
    /// @param owner The address of the token owner
    /// @param spender The address authorized to spend the tokens
    /// @return allowance_ The amount of tokens that the spender is allowed to spend from the owner's account
    function allowance(address owner, address spender) external view returns (uint256);

    /// @notice Approves a spender to spend a specific amount of the caller’s tokens
    /// @dev This function allows the spender to spend a specific amount of the caller’s tokens.
    /// @param spender The address authorized to spend the tokens
    /// @param amount The amount of tokens the spender is allowed to spend
    /// @return success Returns true if the approval is successful
    function approve(address spender, uint256 amount) external returns (bool);

    /// @notice Transfers tokens from one account to another using allowance
    /// @dev This function allows the spender to transfer tokens from the owner's account to a recipient's account.
    /// @param sender The address of the account from which tokens will be transferred
    /// @param recipient The address to which tokens will be transferred
    /// @param amount The amount of tokens to transfer
    /// @return success Returns true if the transfer is successful
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // Event emitted when a transfer of tokens occurs
    /// @notice Emitted when tokens are transferred between accounts
    /// @param from The address from which tokens are transferred
    /// @param to The address to which tokens are transferred
    /// @param value The amount of tokens transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Event emitted when a spender is approved to spend tokens on behalf of an owner
    /// @notice Emitted when an owner approves a spender to use tokens
    /// @param owner The address that owns the tokens
    /// @param spender The address authorized to spend the tokens
    /// @param value The amount of tokens the spender is allowed to spend
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
