// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondLoupe} from "../interfaces/IDiamondLoupe.sol"; 

/// @title DiamondLoupeFacet
/// @notice This facet provides functions for retrieving the facets and their selectors
/// used by a Diamond contract, as well as checking the interfaces supported by the Diamond.
/// It implements the DiamondLoupe and ERC-165 standards.
contract DiamondLoupeFacet is IDiamondLoupe {

    // This mapping stores the function selectors for each facet address
    mapping(address => bytes4[]) public facetFunctionSelectorsMap;
    
    // This array stores the addresses of all the facets
    address[] public facetAddressesList;

    /// @notice Add a new facet and its function selectors
    /// @dev Adds the facet's address and its function selectors to the internal mappings
    /// @param _facetAddress The address of the facet to add
    /// @param _functionSelectors The function selectors associated with the facet
    function addFacet(address _facetAddress, bytes4[] memory _functionSelectors) external {
        require(_facetAddress != address(0), "DiamondLoupeFacet: Facet address cannot be zero");
        require(_functionSelectors.length > 0, "DiamondLoupeFacet: No function selectors provided");

        // Add the facet address and function selectors to the mappings
        facetAddressesList.push(_facetAddress);
        facetFunctionSelectorsMap[_facetAddress] = _functionSelectors;
    }

    /// @notice Gets the list of facet addresses
    /// @return facetAddresses_ An array of addresses representing all the facets
    function facetAddresses() external view override returns (address[] memory) {
        return facetAddressesList;
    }

    /// @notice Gets the function selectors for a specific facet
    /// @param _facetAddress The address of the facet whose selectors are to be fetched
    /// @return facetFunctionSelectors_ An array of function selectors associated with the facet
    function facetFunctionSelectors(address _facetAddress) external view override returns (bytes4[] memory) {
        return facetFunctionSelectorsMap[_facetAddress];
    }

    /// @notice Get the facet address that supports the given function selector
    /// @dev If the function selector is not found, returns address(0)
    /// @param _functionSelector The function selector whose facet address is to be fetched
    /// @return facet_ The address of the facet that supports the provided function selector
    function facetAddress(bytes4 _functionSelector) external view override returns (address facet_) {
        for (uint i = 0; i < facetAddressesList.length; i++) {
            if (_functionSelector == facetFunctionSelectorsMap[facetAddressesList[i]][0]) {
                facet_ = facetAddressesList[i];
                break;
            }
        }
        return facet_;
    }
}
