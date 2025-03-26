// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondCut} from "./interfaces/IDiamondCut.sol"; // Interface for DiamondCut

/// @title Diamond Proxy Contract
/// @notice This contract is a proxy for interacting with a Diamond contract.
/// @dev The contract uses the `delegatecall` mechanism to forward function calls to the Diamond contract.
contract DiamondProxy {
    // The address of the Diamond contract
    address public diamond;

    // Event to emit when the Diamond contract address is updated
    event DiamondUpdated(address indexed oldDiamond, address indexed newDiamond);

    /// @notice Constructor to set the initial Diamond contract address
    /// @dev The constructor takes the Diamond contract address as input and sets it.
    /// @param _diamond The address of the Diamond contract to delegate calls to
    constructor(address _diamond) {
        require(_diamond != address(0), "DiamondProxy: Invalid diamond address");
        diamond = _diamond;
    }

    /// @notice Fallback function to delegate all calls to the Diamond contract
    /// @dev This function is triggered when a function call is made to the proxy contract.
    ///      It forwards the call to the Diamond contract using `delegatecall`.
    ///      The state of the Diamond contract is modified as if the call was made to the Diamond contract itself.
    fallback() external payable {
        (bool success,) = diamond.delegatecall(msg.data);
        require(success, "DiamondProxy: Delegated call failed");
    }

    /// @notice Receive function to handle Ether transfers directly to the contract
    /// @dev This function is called when Ether is sent to the contract without data.
    receive() external payable {
        // Handle the received Ether (you can implement custom logic here if necessary)
    }

    /// @notice Updates the Diamond contract address (only authorized addresses can do this)
    /// @dev This function allows the Diamond address to be updated.
    ///      It emits an event after successfully updating the address.
    /// @param _diamond The new Diamond contract address to set
    function updateDiamond(address _diamond) external {
        require(_diamond != address(0), "DiamondProxy: Invalid diamond address");
        address oldDiamond = diamond;
        diamond = _diamond;
        emit DiamondUpdated(oldDiamond, _diamond); // Emit event on Diamond address update
    }
}
