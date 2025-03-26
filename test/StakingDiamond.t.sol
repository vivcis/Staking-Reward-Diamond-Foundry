// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/Diamond.sol";
import "../contracts/facets/StakingFacet.sol";
import "../contracts/facets/ERC20Facet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/interfaces/IERC20.sol";
import "../contracts/interfaces/IDiamondCut.sol";
import "../test/ERC721Mock.sol";
import "../test/ERC20Mock.sol";

contract StakingDiamondTest is Test {
    Diamond diamond;
    StakingFacet stakingFacet;
    ERC20RewardFacet rewardFacet;
    ERC20Mock rewardToken;

    address[] facets;

    function setUp() public {
        // Deploy the Diamond contract
        diamond = new Diamond();
        
        // Deploy facets
        stakingFacet = new StakingFacet();
        rewardFacet = new ERC20RewardFacet();
        DiamondLoupeFacet diamondLoupeFacet = new DiamondLoupeFacet();

        // Initialize facets (like setting the reward rate in AppStorage)
        stakingFacet.initialize(1000);

        // Create an array to hold facet addresses
        facets = new address ;
        
        // Add the facet addresses to the facets array
        facets[0] = address(stakingFacet);
        facets[1] = address(rewardFacet);
        facets[2] = address(diamondLoupeFacet);

        // Upgrade the Diamond contract with the facets
        IDiamondCut(address(diamond)).diamondCut(facets, address(0), "");

        // Create mock ERC20 token and mint some tokens for testing
        rewardToken = new ERC20Mock();
        rewardToken.mint(address(this), 1000);
    }

    // Test 1: Stake and claim rewards
    function testStakeAndClaimRewards() public {
        uint256 initialBalance = rewardToken.balanceOf(address(this));

        // Staking 100 ERC20 tokens
        stakingFacet.stakeERC20(address(rewardToken), 100);

        // Distribute rewards based on the staking
        rewardFacet.distributeRewards(address(rewardToken));

        // Claim rewards
        rewardFacet.claimRewards(address(rewardToken));

        uint256 finalBalance = rewardToken.balanceOf(address(this));

        // Ensure that the balance increased after claiming rewards
        assert(finalBalance > initialBalance);

        //ensure the balance increased by 100
        assert(finalBalance == initialBalance + 100); 
    }

    // Test 2: Withdraw staked ERC20 tokens
    function testWithdrawERC20() public {
        uint256 initialBalance = rewardToken.balanceOf(address(this));

        // Staking 100 ERC20 tokens
        stakingFacet.stakeERC20(address(rewardToken), 100);

        // Withdraw the staked tokens
        stakingFacet.withdrawERC20(address(rewardToken), 100);

        uint256 finalBalance = rewardToken.balanceOf(address(this));

        // Ensure that the balance is restored after withdrawal
        assert(finalBalance == initialBalance);
    }

    // Test 3: Stake more tokens and check balance change
    function testStakeMoreERC20() public {
        uint256 initialBalance = rewardToken.balanceOf(address(this));

        // Staking 100 ERC20 tokens
        stakingFacet.stakeERC20(address(rewardToken), 100);

        // Stake additional 50 tokens
        stakingFacet.stakeERC20(address(rewardToken), 50);

        uint256 finalBalance = rewardToken.balanceOf(address(this));

        // Ensure the balance decreased correctly after staking
        assert(finalBalance == initialBalance - 150);
    }

    // Test 4: Ensure rewards distribution is proportional to stakes
    function testRewardsDistribution() public {
        uint256 initialBalance = rewardToken.balanceOf(address(this));

        // Stake 100 ERC20 tokens
        stakingFacet.stakeERC20(address(rewardToken), 100);

        // Distribute rewards
        rewardFacet.distributeRewards(address(rewardToken));

        uint256 reward = rewardToken.balanceOf(address(this)) - initialBalance;
        // Ensure rewards are distributed correctly (simplified assumption here)
        assert(reward > 0);
    }

    // Test 5: Ensure rewards can be claimed multiple times
    function testMultipleClaims() public {
        uint256 initialBalance = rewardToken.balanceOf(address(this));

        // Stake 100 ERC20 tokens
        stakingFacet.stakeERC20(address(rewardToken), 100);

        // Distribute rewards twice
        rewardFacet.distributeRewards(address(rewardToken));
        rewardFacet.distributeRewards(address(rewardToken));

        // Claim rewards twice
        rewardFacet.claimRewards(address(rewardToken));
        rewardFacet.claimRewards(address(rewardToken));

        uint256 finalBalance = rewardToken.balanceOf(address(this));

        // Ensure balance increased after multiple claims
        assert(finalBalance > initialBalance);
    }

    // Test 6: Ensure balance decreases after withdrawal
    function testBalanceAfterWithdraw() public {
        uint256 initialBalance = rewardToken.balanceOf(address(this));

        // Stake 100 tokens
        stakingFacet.stakeERC20(address(rewardToken), 100);

        // Withdraw 50 tokens
        stakingFacet.withdrawERC20(address(rewardToken), 50);

        uint256 finalBalance = rewardToken.balanceOf(address(this));

        // Ensure balance decreased correctly after withdrawal
        assert(finalBalance == initialBalance + 50);
    }

    // Test 7: Prevent withdrawing more tokens than staked
    function testWithdrawMoreThanStaked() public {
        // Stake 100 tokens
        stakingFacet.stakeERC20(address(rewardToken), 100);

        // Try withdrawing more than staked
        try stakingFacet.withdrawERC20(address(rewardToken), 200) {
            fail("Expected error not thrown");
        } catch (bytes memory) {
            //ensure error is thrown
            assert(true);
        }
    }

    // Test 8: Check if facet functions are correctly upgraded
    function testFacetUpgrade() public {
        address initialFacet = address(stakingFacet);
        // Upgrade facet and check if the address changes
        stakingFacet = new StakingFacet();
        assert(address(stakingFacet) != initialFacet);
    }

    // Test 9: Check if Diamond contract is upgraded with facets
    function testDiamondUpgrade() public {
        // Add more facets to the Diamond contract
        address initialFacet = facets[0];
        diamond.diamondCut(facets);

        assert(facets[0] != initialFacet);
    }

    // Test 10: Verify total staked tokens
    function testTotalStakedTokens() public {
        uint256 totalStakedBefore = stakingFacet.totalStakedERC20();

        // Stake 100 tokens
        stakingFacet.stakeERC20(address(rewardToken), 100);

        uint256 totalStakedAfter = stakingFacet.totalStakedERC20();

        // Ensure the total staked amount increases correctly
        assert(totalStakedAfter == totalStakedBefore + 100);
    }

    // Test 11: Claim rewards and check if balance increases
    function testClaimRewardsBalanceIncrease() public {
        uint256 initialBalance = rewardToken.balanceOf(address(this));

        // Stake 100 tokens
        stakingFacet.stakeERC20(address(rewardToken), 100);

        // Distribute and claim rewards
        rewardFacet.distributeRewards(address(rewardToken));
        rewardFacet.claimRewards(address(rewardToken));

        uint256 finalBalance = rewardToken.balanceOf(address(this));

        // Ensure balance increased after claiming
        assert(finalBalance > initialBalance);
    }

    // Test 12: Stake ERC721 tokens and withdraw them
    function testStakeAndWithdrawERC721() public {

        //deploy ERC721 token
        ERC721Mock token = new ERC721Mock();  
        uint256 tokenId = 1;

        //mint the ERC721 token
        token.mint(address(this), tokenId);

        // Stake ERC721 token
        stakingFacet.stakeERC721(address(token), tokenId);

        // Withdraw the staked ERC721 token
        stakingFacet.withdrawERC721(address(token), tokenId);

        // Ensure that the ERC721 token is properly withdrawn
        assert(token.ownerOf(tokenId) == address(this));
    }
}
