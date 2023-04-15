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
    ) ERC1155("https://my-api-url.com/api/token/%22") {
        addToWLGOLD(_GoldUserList);
        addToWLSilver(_SilverUserList);
        addToWLBronze(_BronzeUserList);
    }

    function uri(uint256 id) public view override returns (string memory) {
        if (id == UniswapGold) {
            return
                "https://ipfs.io/ipfs/QmPHTFuXUVRSckXPj7tBtRavMpMoNypvm99EzUUnUBRWrM?filename=json_gold.json";
        } else if (id == UniswapSilver) {
            return
                "https://ipfs.io/ipfs/QmXpagCEXBNXKws7pMr89gMC278X16AFv1vLGaQ1GiMn1h?filename=silver.json";
        } else if (id == UniswapBronze) {
            return
                "https://ipfs.io/ipfs/QmZkr8bWEA3yZ7ozaUtXDDSYF9AwzoDVQPBYEn4igfJmGk?filename=bronze.json";
        }

        revert("Unknown token ID");
    }

    function uint256ToString(
        uint256 num
    ) internal pure returns (string memory) {
        if (num == 0) {
            return "0";
        }
        uint256 temp = num;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (num != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + (num % 10)));
            num /= 10;
        }
        return string(buffer);
    }

    function addToWLGOLD(address[] memory _GoldUserList) internal {
        for (uint256 i = 0; i < _GoldUserList.length; i++) {
            WLGold[_GoldUserList[i]] = true;
        }
        GoldUserList = _GoldUserList;
    }

    function addToWLSilver(address[] memory _SilverUserList) internal {
        for (uint256 i = 0; i < _SilverUserList.length; i++) {
            WLSilver[_SilverUserList[i]] = true;
        }
        SilverUserList = _SilverUserList;
    }

    function addToWLBronze(address[] memory _BronzeUserList) internal {
        for (uint256 i = 0; i < _BronzeUserList.length; i++) {
            WLBronze[_BronzeUserList[i]] = true;
        }
        BronzeUserList = _BronzeUserList;
    }

    function mintGoldNFT() public {
        require(WLGold[msg.sender], "Caller is not in the gold whitelist");
        require(!isMinted[msg.sender], "NFT already minted for the caller");
        isMinted[msg.sender] = true;
        _mint(msg.sender, UniswapGold, 1, "");
    }

    function mintSilverNFT() public {
        require(WLSilver[msg.sender], "Caller is not in the silver whitelist");
        require(!isMinted[msg.sender], "NFT already minted for the caller");
        isMinted[msg.sender] = true;
        _mint(msg.sender, UniswapSilver, 1, "");
    }

    function mintBronzeNFT() public {
        require(WLBronze[msg.sender], "Caller is not in the bronze whitelist");
        require(!isMinted[msg.sender], "NFT already minted for the caller");
        isMinted[msg.sender] = true;
        _mint(msg.sender, UniswapBronze, 1, "");
    }
}
