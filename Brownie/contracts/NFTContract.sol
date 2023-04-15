// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTContract is ERC1155, Ownable {
    mapping(address => bool) public WLGold;
    mapping(address => bool) public WLSilver;
    mapping(address => bool) public WLBronze;
    mapping(address => bool) public isMinted;

    uint256 public constant UniswapGold = 0;
    uint256 public constant UniswapSilver = 1;
    uint256 public constant UniswapBronze = 2;

    address[] GoldUserList;
    address[] SilverUserList;
    address[] BronzeUserList;

    constructor(
        address[] memory _GoldUserList,
        address[] memory _SilverUserList,
        address[] memory _BronzeUserList
    ) ERC1155("https://my-api-url.com/api/token/{id}") {
        GoldUserList = _GoldUserList;
        SilverUserList = _SilverUserList;
        BronzeUserList = _BronzeUserList;
    }

    function addToWLGOLD(address[] memory goldUsers) public onlyOwner {
        for (uint256 i = 0; i < goldUsers.length; i++) {
            WLGold[goldUsers[i]] = true;
        }
    }

    function addToWLSilver(address[] memory silverUsers) public onlyOwner {
        for (uint256 i = 0; i < silverUsers.length; i++) {
            WLSilver[silverUsers[i]] = true;
        }
    }

    function addToWLBronze(address[] memory bronzeUsers) public onlyOwner {
        for (uint256 i = 0; i < bronzeUsers.length; i++) {
            WLBronze[bronzeUsers[i]] = true;
        }
    }

    function mintGoldNFT() public {
        require(WLGold[msg.sender], "Caller is not in the gold whitelist");
        require(!isMinted[msg.sender], "NFT already minted for the caller");
        isMinted[msg.sender] = true;
        _mint(msg.sender, UniswapGold, 1, "");
    }

    function mintSilverNFT() public {
        require(WLSilver[msg.sender], "Caller is not in the gold whitelist");
        require(!isMinted[msg.sender], "NFT already minted for the caller");
        isMinted[msg.sender] = true;
        _mint(msg.sender, UniswapSilver, 1, "");
    }

    function mintBronzeNFT() public {
        require(WLBronze[msg.sender], "Caller is not in the gold whitelist");
        require(!isMinted[msg.sender], "NFT already minted for the caller");
        isMinted[msg.sender] = true;
        _mint(msg.sender, UniswapBronze, 1, "");
    }
}
