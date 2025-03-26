// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import {Diamond} from "../contracts/Diamond.sol";  
// import {StakingFacet} from "../contracts/facets/StakingFacet.sol";  
// import {ERC20RewardFacet} from "../contracts/facets/ERC20Facet.sol";  
// import {DiamondLoupeFacet} from "../contracts/facets/DiamondLoupeFacet.sol";
// import {IDiamondCut} from "../contracts/interfaces/IDiamondCut.sol";  

// /// @title Deploy Contract
// /// @notice This contract is used for deploying and initializing the Diamond contract with facets.
// /// @dev It deploys the Diamond contract, facets, and then upgrades the Diamond contract using diamondCut.
// contract DiamondDeployer {
//     // Declare the facets and Diamond contract variables
//     Diamond diamond;
//     StakingFacet stakingFacet;
//     ERC20RewardFacet rewardFacet;
//     DiamondLoupeFacet diamondLoupeFacet;

//     /// @notice This function deploys the Diamond contract, facets, and upgrades the Diamond contract.
//     /// @dev Deploys the Diamond contract and facets, then calls diamondCut to add the facets.
//     function run() public {
//         // Deploy the Diamond contract
//         diamond = new Diamond();
        
//         // Deploy facets
//         stakingFacet = new StakingFacet();
//         rewardFacet = new ERC20RewardFacet();
//         diamondLoupeFacet = new DiamondLoupeFacet();  

//         // Initialize facets (like setting the reward rate in AppStorage)
//         stakingFacet.initialize(1000); // Set the reward rate (or any other initialization needed)

//         // Declare the facets array to hold the facet addresses (with size 3 for 3 facets)
//         address ;  // Declare the array with size 3

//         // Add the facet addresses to the facets array
//         facets[0] = address(stakingFacet);
//         facets[1] = address(rewardFacet);
//         facets[2] = address(diamondLoupeFacet);  // Add DiamondLoupeFacet address

//         // Upgrade the Diamond contract with the facets
//         IDiamondCut(address(diamond)).diamondCut(facets, address(0), "");

//         // Call facetAddresses to check if the facets are correctly linked
//         address[] memory facetAddresses = DiamondLoupeFacet(address(diamond)).facetAddresses();

//         // You can now use facetAddresses to ensure the facets were correctly linked
//         // For example, check the addresses manually (or assert in a test framework)
//         for (uint i = 0; i < facetAddresses.length; i++) {
//             // Print the facet addresses (for debugging purposes)
//             console.log(facetAddresses[i]);
//         }
//     }
// }
