// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDiamondCut {
    /// @notice Struct for facet cut operations (add, replace, remove facets)
    /// @dev This struct defines how a facet cut should be performed.
    /// @param facetAddress The address of the facet to be added, replaced, or removed
    /// @param action The action to be performed: Add, Replace, or Remove
    /// @param functionSelectors The list of function selectors to be added or removed from the facet
    struct FacetCut {
        address facetAddress; // The address of the facet to add/remove/replace
        uint8 action; // Action to perform: Add, Replace, Remove
        bytes4[] functionSelectors; // List of function selectors associated with the facet
    }

    /// @notice Enum for the facet cut actions (Add, Replace, Remove)
    /// @dev Used in the `diamondCut` function to specify the action for the facet
    enum FacetCutAction {
        Add, // Add a facet and function selectors
        Replace, // Replace an existing facet or function selectors
        Remove // Remove a facet or function selectors

    }

    /// @notice Perform a diamond cut operation (add/remove facets)
    /// @dev This function allows adding, replacing, or removing facets in a diamond contract.
    ///      It is used to modify the facets of the diamond during runtime.
    /// @param _diamondCut An array of `FacetCut` structs specifying the facets to add/remove/replace
    /// @param _init The address to initialize the diamond cut. Can be set to address(0) if no initialization is required.
    /// @param _calldata The calldata to pass to the initializer address if needed.
    function diamondCut(FacetCut[] calldata _diamondCut, address _init, bytes calldata _calldata) external;
}
