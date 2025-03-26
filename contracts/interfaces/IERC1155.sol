// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC1155 {
    /// @notice Returns the balance of a specific token for a given account
    /// @dev This function provides the balance of a specific token owned by the specified account.
    /// @param account The address of the account to query the balance of
    /// @param id The ID of the token to query
    /// @return balance The number of tokens owned by the account for the specified token ID
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /// @notice Returns the balances of specific tokens for multiple accounts
    /// @dev This function allows querying the balances of multiple tokens for multiple accounts.
    /// @param accounts The list of account addresses to query
    /// @param ids The list of token IDs to query
    /// @return balances The list of balances corresponding to the token IDs and accounts
    function balanceOfBatch(address[] memory accounts, uint256[] memory ids) external view returns (uint256[] memory);

    /// @notice Transfers a specific amount of a token to another address
    /// @dev This function transfers a specified amount of a specific token from one address to another.
    ///      It ensures that the transfer is safe and checks that the recipient is capable of receiving the token.
    /// @param from The address of the sender
    /// @param to The address of the recipient
    /// @param id The ID of the token being transferred
    /// @param amount The amount of the token being transferred
    /// @param data Additional data passed to the recipient (if needed)
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;

    /// @notice Transfers multiple types of tokens to another address in a batch
    /// @dev This function transfers multiple types of tokens to a recipient in a single batch transfer.
    ///      It ensures that each transfer is safe and verifies that the recipient can handle the tokens.
    /// @param from The address of the sender
    /// @param to The address of the recipient
    /// @param ids The array of token IDs being transferred
    /// @param amounts The array of token amounts being transferred
    /// @param data Additional data passed to the recipient (if needed)
    function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes calldata data) external;

    /// @notice Emitted when a single transfer of tokens occurs
    /// @dev This event is emitted after a successful transfer of a specific token ID from one address to another.
    /// @param operator The address that initiated the transfer
    /// @param from The address from which the tokens were transferred
    /// @param to The address to which the tokens were transferred
    /// @param id The ID of the token being transferred
    /// @param value The amount of the token being transferred
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /// @notice Emitted when a batch transfer of tokens occurs
    /// @dev This event is emitted after a successful batch transfer of tokens from one address to another.
    /// @param operator The address that initiated the transfer
    /// @param from The address from which the tokens were transferred
    /// @param to The address to which the tokens were transferred
    /// @param ids The array of token IDs being transferred
    /// @param values The array of token amounts being transferred
    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);

    /// @notice Emitted when an account is approved to manage another account's tokens
    /// @dev This event is triggered when an account (`operator`) is approved or revoked as an operator for another account (`account`).
    /// @param account The address of the token holder
    /// @param operator The address of the operator being approved or revoked
    /// @param approved A boolean value indicating whether the operator is approved (true) or revoked (false)
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
}
