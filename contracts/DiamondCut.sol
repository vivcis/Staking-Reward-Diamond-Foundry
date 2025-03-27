// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondCut} from "./interfaces/IDiamondCut.sol"; 

/// @title DiamondCut Contract
/// @notice This contract is responsible for adding, removing, or replacing facets in a Diamond contract.
/// @dev The DiamondCut contract implements the `IDiamondCut` interface, enabling modification of facets dynamically.
contract DiamondCut is IDiamondCut {
    
    // map facet addresses to function selectors
    mapping(address => bytes4[]) public facetFunctionSelectors;

    // map function selectors to facet addresses
    mapping(bytes4 => address) public selectorToFacet;

    // Events for facet management
    event FacetAdded(address indexed facetAddress, bytes4[] functionSelectors);
    event FacetReplaced(address indexed oldFacetAddress, address indexed newFacetAddress, bytes4[] functionSelectors);
    event FacetRemoved(address indexed facetAddress, bytes4[] functionSelectors);
    event FacetInitialized(address indexed facetAddress);  

    /// @notice Adds, replaces, or removes facets in the Diamond contract
    /// @dev This function allows for dynamic updates to the Diamond contract's facets.
    ///      It accepts an array of `FacetCut` actions to modify the facets and their function selectors.
    ///      The function ensures that the correct action (Add, Replace, Remove) is performed for each facet.
    /// @param _diamondCut An array of `FacetCut` structs that define the facets and the action to perform on each
    /// @param _init The address of the contract to initialize after facet updates (optional)
    /// @param _calldata The calldata to be passed to the initializer contract (if `_init` is not `address(0)`)
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {
        // Loop through each facet cut and execute the corresponding action
        for (uint i = 0; i < _diamondCut.length; i++) {
            FacetCut memory cut = _diamondCut[i];
            
            // Use integer comparison for enum values
            if (uint8(cut.action) == uint8(FacetCutAction.Add)) {
                _addFacet(cut.facetAddress, cut.functionSelectors);
            } else if (uint8(cut.action) == uint8(FacetCutAction.Replace)) {
                _replaceFacet(cut.facetAddress, cut.functionSelectors);
            } else if (uint8(cut.action) == uint8(FacetCutAction.Remove)) {
                _removeFacet(cut.facetAddress, cut.functionSelectors);
            }
        }

        // If an initializer contract is provided, perform the delegatecall for initialization
        if (_init != address(0)) {
            (bool success, ) = _init.delegatecall(_calldata);
            require(success, "DiamondCut: Initialization failed");
            emit FacetInitialized(_init);  // Emit the event for facet initialization
        }
    }

    /// @notice Internal function to add a facet to the Diamond contract
    /// @dev This function adds a new facet to the Diamond contract and updates the facet address mapping.
    ///      It ensures that the facet address is valid and that the function selectors are not already present.
    /// @param _facetAddress The address of the facet to add
    /// @param _functionSelectors The list of function selectors associated with the facet
    function _addFacet(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        require(_facetAddress != address(0), "DiamondCut: Facet address cannot be zero");

        for (uint i = 0; i < _functionSelectors.length; i++) {
            bytes4 selector = _functionSelectors[i];
            // Ensure the selector isn't already in use by another facet
            require(selectorToFacet[selector] == address(0), "DiamondCut: Function selector already in use");

            // Map the selector to the facet
            selectorToFacet[selector] = _facetAddress;

            // Add the function selector to the facet's list of selectors
            facetFunctionSelectors[_facetAddress].push(selector);
        }

        emit FacetAdded(_facetAddress, _functionSelectors); // Emit event for facet addition
    }

    /// @notice Internal function to replace an existing facet in the Diamond contract
    /// @dev This function replaces an existing facet with a new one.
    ///      It ensures that the facet exists and is replaced correctly, while updating the facet address mapping.
    /// @param _facetAddress The address of the new facet to replace the existing facet
    /// @param _functionSelectors The list of function selectors to replace in the existing facet
    function _replaceFacet(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        require(_facetAddress != address(0), "DiamondCut: Facet address cannot be zero");

        for (uint i = 0; i < _functionSelectors.length; i++) {
            bytes4 selector = _functionSelectors[i];
            address existingFacet = selectorToFacet[selector];
            require(existingFacet != address(0), "DiamondCut: Selector not found");

            // Replace the existing facet with the new facet address
            selectorToFacet[selector] = _facetAddress;

            // Replace the function selector in the facet's list of selectors
            // Removing the old facet address from the facetFunctionSelectors mapping
            _removeFacet(existingFacet, _functionSelectors);

            // Add the new function selector to the new facet's list
            facetFunctionSelectors[_facetAddress].push(selector);
        }

        // emit FacetReplaced(existingFacet, _facetAddress, _functionSelectors); 
    }

    /// @notice Internal function to remove a facet from the Diamond contract
    /// @dev This function removes a facet from the Diamond contract.
    ///      It ensures that the facet is properly removed and the facet address mapping is updated.
    /// @param _facetAddress The address of the facet to remove
    /// @param _functionSelectors The list of function selectors associated with the facet to remove
    function _removeFacet(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        require(_facetAddress != address(0), "DiamondCut: Facet address cannot be zero");

        for (uint i = 0; i < _functionSelectors.length; i++) {
            bytes4 selector = _functionSelectors[i];
            require(selectorToFacet[selector] == _facetAddress, "DiamondCut: Function selector not found");

            // Remove the function selector from the mapping
            delete selectorToFacet[selector];

            // Remove the function selector from the facet's list of selectors
            _removeFromFacetSelectorList(_facetAddress, selector);
        }

        emit FacetRemoved(_facetAddress, _functionSelectors); // Emit event for facet removal
    }

    /// @notice Internal function to remove a function selector from a facet's selector list
    /// @dev This function is used to remove a function selector from the given facet's list of selectors.
    /// @param _facetAddress The address of the facet
    /// @param _selector The function selector to remove
    function _removeFromFacetSelectorList(address _facetAddress, bytes4 _selector) internal {
        bytes4[] storage selectors = facetFunctionSelectors[_facetAddress];
        for (uint i = 0; i < selectors.length; i++) {
            if (selectors[i] == _selector) {
                selectors[i] = selectors[selectors.length - 1];
                selectors.pop();
                return;
            }
        }
        revert("DiamondCut: Function selector not found in facet");
    }
}
