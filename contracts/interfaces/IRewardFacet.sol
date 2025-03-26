// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRewardFacet {
    /// @notice Distribute rewards to users based on their staking balances
    /// @dev This function calculates and distributes rewards based on the total amount of tokens staked
    ///      across various token types (ERC20, ERC721, ERC1155) to the users.
    /// @param rewardToken The address of the reward token to be distributed
    function distributeRewards(address rewardToken) external;

    /// @notice Claim accumulated rewards for a user
    /// @dev This function allows a user to claim their rewards based on their staking balance
    ///      in the specified reward token. The reward is calculated based on the user's staking history.
    /// @param rewardToken The address of the reward token to be claimed
    function claimRewards(address rewardToken) external;
}
