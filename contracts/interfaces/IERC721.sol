// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    /// @notice Returns the number of tokens owned by a specific address
    /// @dev This function provides the number of tokens that an address owns. 
    /// @param owner The address whose token balance is being queried
    /// @return balance The number of tokens owned by the specified address
    function balanceOf(address owner) external view returns (uint256);

    /// @notice Returns the owner of a given token ID
    /// @dev This function returns the address of the current owner of the specified token ID.
    /// @param tokenId The ID of the token to query
    /// @return owner The address that owns the specified token
    function ownerOf(uint256 tokenId) external view returns (address);

    /// @notice Safely transfers a token from one address to another
    /// @dev This function transfers the ownership of a token from one address to another, 
    ///      checking that the recipient is capable of receiving the token.
    /// @param from The address transferring the token
    /// @param to The address receiving the token
    /// @param tokenId The ID of the token being transferred
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /// @notice Transfers a token from one address to another
    /// @dev This function transfers the ownership of a token from one address to another 
    ///      without any safety checks.
    /// @param from The address transferring the token
    /// @param to The address receiving the token
    /// @param tokenId The ID of the token being transferred
    function transferFrom(address from, address to, uint256 tokenId) external;

    /// @notice Approves another address to transfer a given token ID
    /// @dev This function allows the `to` address to transfer the specified `tokenId` on behalf of the owner.
    /// @param to The address being approved to transfer the token
    /// @param tokenId The ID of the token to approve
    function approve(address to, uint256 tokenId) external;

    /// @notice Returns the address approved to transfer a given token ID
    /// @dev This function returns the address that is approved to transfer the specified `tokenId`.
    /// @param tokenId The ID of the token being queried
    /// @return approved The address that is approved to transfer the specified token
    function getApproved(uint256 tokenId) external view returns (address);

    /// @notice Approves or revokes permission for an operator to manage all of the owner's tokens
    /// @dev This function allows the `operator` to manage all tokens owned by `owner`, or revoke this permission.
    /// @param operator The address of the operator to approve or revoke
    /// @param approved Boolean value to approve or revoke the operator
    function setApprovalForAll(address operator, bool approved) external;

    /// @notice Checks if an operator is approved to manage all of an owner's tokens
    /// @dev This function returns whether the `operator` is allowed to manage all of `owner`'s tokens.
    /// @param owner The address of the token owner
    /// @param operator The address of the operator to check
    /// @return isApproved A boolean value indicating whether the operator is approved
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    // Event emitted when a transfer of a token occurs
    /// @notice Emitted when a token is transferred from one address to another
    /// @param from The address transferring the token
    /// @param to The address receiving the token
    /// @param tokenId The ID of the token being transferred
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    // Event emitted when a token is approved for transfer by another address
    /// @notice Emitted when an address is approved to transfer a given token
    /// @param owner The owner of the token
    /// @param approved The address approved to transfer the token
    /// @param tokenId The ID of the token being approved
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    // Event emitted when approval is granted or revoked for an operator to manage all of an owner's tokens
    /// @notice Emitted when an operator is granted or revoked permission to manage all of the owner's tokens
    /// @param owner The address granting or revoking approval
    /// @param operator The address of the operator being granted or revoked approval
    /// @param approved Boolean value indicating whether approval is granted (true) or revoked (false)
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
}
