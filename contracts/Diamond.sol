// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondProxy} from "./interfaces/IDiamondProxy.sol";
import {AppStorage} from "./libraries/AppStorage.sol";

/// @title Diamond Contract
/// @notice This contract implements the Diamond Proxy pattern, allowing dynamic addition and removal of facets.
/// @dev The Diamond contract implements the `IDiamondProxy` interface, enabling facet management and delegate calls to facets.
contract Diamond is IDiamondProxy {
    // Mapping to store the facet addresses and their selectors
    mapping(bytes4 => address) public selectorToFacet;
    mapping(address => bytes4[]) public facetFunctionSelectors;

    // Array to store the facet addresses
    address[] public facetAddressesList;

    /// @notice Adds or removes facets from the Diamond contract
    /// @dev This function is used to modify the Diamond contract’s facets by adding or removing facets dynamically.
    ///      It accepts an array of facet addresses and adds or removes them depending on the specified action.
    /// @param _facets An array of facet addresses to be added or removed from the Diamond contract
    function diamondCut(address[] calldata _facets) external override {
        for (uint256 i = 0; i < _facets.length; i++) {
            address facetAddress = _facets[i];

            // If the facet is a dummy address, we know it needs to be removed.
            if (facetAddress == address(0)) {
                _removeFacet(facetAddress);
            } else {
                _addFacet(facetAddress);
            }
        }
    }

    /// @notice Returns the addresses of all current facets in the Diamond contract
    /// @dev This function allows querying the addresses of the facets that are currently part of the Diamond contract.
    /// @return facetAddresses_ An array of addresses representing the facets in the Diamond contract
    function facetAddresses() external view override returns (address[] memory facetAddresses_) {
        facetAddresses_ = new address[](facetAddressesList.length);
        for (uint256 i = 0; i < facetAddressesList.length; i++) {
            facetAddresses_[i] = facetAddressesList[i];
        }
    }

    /// @notice Delegates a call to a specific facet address
    /// @dev This function forwards the call and data to a facet address, allowing the facet to execute the logic.
    ///      If the call fails, it reverts with "Delegate call failed".
    /// @param _facet The address of the facet to delegate the call to
    /// @param _data The data to be passed along with the delegate call
    function delegateCall(address _facet, bytes calldata _data) external override {
        // Delegate the call to the facet
        (bool success, ) = _facet.delegatecall(_data);
        
        // Require that the delegate call succeeds
        require(success, "DiamondProxy: Delegate call failed");
    }

    // Internal function to add a facet to the Diamond contract
    function _addFacet(address _facetAddress) internal {
        require(_facetAddress != address(0), "Diamond: Invalid facet address");

        // Example dummy selector (use actual selectors for your real use case)
        bytes4 dummySelector = bytes4(keccak256("dummyFunction()"));

        // Add the facet address to the mapping
        selectorToFacet[dummySelector] = _facetAddress;

        // Add the selector to the facet's list
        facetFunctionSelectors[_facetAddress].push(dummySelector);

        // Add the facet address to the facetAddressesList if not already present
        bool exists = false;
        for (uint i = 0; i < facetAddressesList.length; i++) {
            if (facetAddressesList[i] == _facetAddress) {
                exists = true;
                break;
            }
        }

        if (!exists) {
            facetAddressesList.push(_facetAddress);
        }
    }

    // Internal function to remove a facet from the Diamond contract
    function _removeFacet(address _facetAddress) internal {
        require(_facetAddress != address(0), "Diamond: Invalid facet address");

        // Example dummy selector (use actual selectors for your real use case)
        bytes4 dummySelector = bytes4(keccak256("dummyFunction()"));

        // Check if the facet exists in the facetFunctionSelectors mapping
        address currentFacet = selectorToFacet[dummySelector];
        require(currentFacet == _facetAddress, "Diamond: Facet not found");

        // Remove the facet address from the selector to facet mapping
        delete selectorToFacet[dummySelector];

        // Remove the selector from the facet's list of selectors
        _removeFromFacetSelectorList(_facetAddress, dummySelector);

        // Remove the facet address from the facetAddressesList
        uint256 index = 0;
        bool found = false;
        for (uint256 i = 0; i < facetAddressesList.length; i++) {
            if (facetAddressesList[i] == _facetAddress) {
                index = i;
                found = true;
                break;
            }
        }

        if (found) {
            facetAddressesList[index] = facetAddressesList[facetAddressesList.length - 1];
            facetAddressesList.pop();
        }
    }

    // Internal function to remove a function selector from a facet's selector list
    function _removeFromFacetSelectorList(address _facetAddress, bytes4 _selector) internal {
        bytes4[] storage selectors = facetFunctionSelectors[_facetAddress];
        
        for (uint256 i = 0; i < selectors.length; i++) {
            if (selectors[i] == _selector) {
                // Swap the element to be removed with the last one, then pop
                selectors[i] = selectors[selectors.length - 1];
                selectors.pop();
                return;
            }
        }
        revert("Diamond: Function selector not found in facet");
    }
}
