// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library AppStorage {
    /// @dev Struct that holds all the storage for the staking logic
    /// @notice This structure contains mappings to track staked tokens (ERC20, ERC721, ERC1155), 
    ///         the total amount of each type of token staked, and the reward-related information.
    struct Storage {
        // ERC20 stakes by user address
        mapping(address => uint256) stakesERC20;
        
        // ERC721 stakes by user address and tokenId
        mapping(address => mapping(uint256 => uint256)) stakesERC721;
        
        // ERC1155 stakes by user address and tokenId and token address
        mapping(address => mapping(address => mapping(uint256 => uint256))) stakesERC1155;

        // Total ERC20 tokens staked
        uint256 totalStakedERC20;

        // Total ERC721 tokens staked
        uint256 totalStakedERC721;

        // Total ERC1155 tokens staked (with support for multiple token types)
        mapping(address => mapping(uint256 => uint256)) totalStakedERC1155;

        // Reward rate per stake
        uint256 rewardRate;

        // Rewards per token staked
        uint256 rewardPerStake;
    }

    // Define the storage slot for accessing the AppStorage state
    /// @notice The STORAGE_SLOT is where the AppStorage state is stored.
    /// @dev This value is used to access the app's storage using inline assembly.
    bytes32 internal constant STORAGE_SLOT = keccak256("diamond.standard.appstorage");

    /// @notice Gets the reference to the AppStorage state
    /// @dev This function allows you to access the app's storage using inline assembly, 
    ///      providing access to the state variables stored in `Storage`.
    /// @return s The reference to the AppStorage storage slot.
    function getStorage() internal pure returns (Storage storage s) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            s.slot := slot
        }
    }

    /// @notice Initializes or resets the storage values
    /// @dev This function sets the initial reward rate and can be used for contract initialization.
    /// @param _rewardRate The initial reward rate to set
    function initializeStorage(uint256 _rewardRate) internal {
        Storage storage s = getStorage();
        s.rewardRate = _rewardRate;  // Set the initial reward rate
    }
}
