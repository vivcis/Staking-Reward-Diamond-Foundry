// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDiamondLoupe {
    /// @notice Gets all the facet addresses used by a Diamond contract
    /// @dev This function returns the addresses of all facets that have been added to the diamond.
    /// @return facetAddresses_ An array of addresses of the facets in the Diamond contract
    function facetAddresses() external view returns (address[] memory);

    /// @notice Gets the function selectors provided by a specific facet
    /// @dev This function returns a list of function selectors that are defined in a given facet address.
    /// @param _facetAddress The address of the facet to query
    /// @return facetFunctionSelectors_ An array of bytes4 selectors that belong to the specified facet
    function facetFunctionSelectors(address _facetAddress) external view returns (bytes4[] memory);

    /// @notice Gets the facet address that supports the given function selector
    /// @dev This function helps identify which facet is responsible for implementing a given function
    ///      based on its selector. If the function is not found, it returns address(0).
    /// @param _functionSelector The function selector to query for
    /// @return facet_ The address of the facet that implements the function corresponding to the selector
    function facetAddress(bytes4 _functionSelector) external view returns (address facet_);
}
