// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDiamondProxy {
    /// @notice Perform a diamond cut operation to add or remove facets
    /// @dev This function is used to add, replace, or remove facets in a Diamond contract.
    ///      It allows you to update the Diamond contract's functionality by adding new facets or removing existing ones.
    /// @param _facets An array of facet addresses to add/remove in the Diamond contract.
    function diamondCut(address[] calldata _facets) external;

    /// @notice Get the addresses of all facets used by the Diamond contract
    /// @dev This function returns an array of addresses of all the facets currently linked to the Diamond contract.
    /// @return facetAddresses_ An array of facet addresses used by the Diamond contract
    function facetAddresses() external view returns (address[] memory);

    /// @notice Delegate a call to a specific facet
    /// @dev This function forwards a call to a specific facet and executes the provided data.
    ///      The call is delegated to the specified facet, and the function does not return any result directly.
    /// @param _facet The address of the facet to delegate the call to.
    /// @param _data The data to be passed along with the call to the facet.
    function delegateCall(address _facet, bytes calldata _data) external;
}
