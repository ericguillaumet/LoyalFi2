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

    function addToWLGOLD(address[] memory GoldUserList) public onlyOwner {
        for (uint256 i = 0; i < GoldUserList.length; i++) {
            WLGold[GoldUserList[i]] = true;
        }
    }

    function addToWLSilver(address[] memory SilverUserList) public onlyOwner {
        for (uint256 i = 0; i < SilverUserList.length; i++) {
            WLSilver[SilverUserList[i]] = true;
        }
    }

    function addToWLBronze(address[] memory BronzeUserList) public onlyOwner {
        for (uint256 i = 0; i < BronzeUserList.length; i++) {
            WLBronze[BronzeUserList[i]] = true;
        }
    }

    function mintGoldNFT() public {
        require(WLGold[msg.sender], "Caller is not in the gold whitelist");
        require(!isMinted[msg.sender], "NFT already minted for the caller");
        isMinted[msg.sender] = true;
        _mint(msg.sender, UniswapGold, 1, "");
    }
}
