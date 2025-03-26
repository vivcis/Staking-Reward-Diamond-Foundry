// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC721} from "../contracts/interfaces/IERC721.sol";

contract ERC721Mock is IERC721 {
    string public name = "Mock ERC721";
    string public symbol = "M721";
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    mapping(uint256 => address) public owners;
    mapping(address => mapping(address => bool)) public operatorApprovals;
    mapping(uint256 => address) public tokenApprovals;

    function mint(address to, uint256 tokenId) public {
        totalSupply += 1;
        balances[to] += 1;
        owners[tokenId] = to;
    }

    function balanceOf(address owner) public view override returns (uint256) {
        return balances[owner];
    }

    function ownerOf(uint256 tokenId) public view override returns (address) {
        return owners[tokenId];
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        require(owners[tokenId] == from, "ERC721Mock: transfer from incorrect owner");
        owners[tokenId] = to;
        balances[from] -= 1;
        balances[to] += 1;
        emit Transfer(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) public override {
        tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId); // Inherited event
    }

    function getApproved(uint256 tokenId) public view override returns (address) {
        return tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public override {
        operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved); // Inherited event
    }

    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        return operatorApprovals[owner][operator];
    }

    // Implementing missing `safeTransferFrom` function to prevent abstract contract error
    function safeTransferFrom(address from, address to, uint256 tokenId) public override {
        transferFrom(from, to, tokenId); // Call the transferFrom function
    }
}
