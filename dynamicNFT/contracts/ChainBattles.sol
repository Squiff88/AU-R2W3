// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// CONTRACT DEPLOYED TO 0x0E559800869C85E0834544f9600CF2DC24ec9579

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => uint256) public tokenIdToLevels;

    constructor() ERC721("Chain Battles", "CBT") {}

    function generateCharacter(uint256 tokenId)
        public
        pure
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg width="200" height="100">'
            '<rect x="0" y="0" width="200" height="100" stroke="black" stroke-width="1px" fill="transparent"/>'
            '<text x="50%" y="50%" fill="white" dominant-baseline="middle" text-anchor="middle">"Levels: ", getLevels(tokenId).</text>'
            "</svg>"
        );

        return
            string(
                abi.encodePacked(
                    "data:image/svg+hml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevels[tokenId];
        return levels.toString();
    }

    function getTokenURI(uint256 tokenId) public pure returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "}",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description" : "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId] = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You cannot interact with this token"
        );
        uint256 currentLevel = tokenIdToLevels[tokenId];
        tokenIdToLevels[tokenId] = currentLevel + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function _burn(uint256 tokenId) internal override(ERC721URIStorage) {}

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721URIStorage)
        returns (string memory)
    {}
}
