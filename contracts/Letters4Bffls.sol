// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.13;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import './Renderer.sol';
import './Utils.sol';

contract Letters2Bffls is ERC721Enumerable, ReentrancyGuard, Ownable {
    struct Letter {
        uint256 id;
        uint256 senderTokenId;
        address sender;
        address[] receivers;
        address receiver;
        LetterData data;
        uint256 timestamp;
    }

    string public baseURI;
    mapping(address => uint256[]) public pendingTokenIds;
    mapping(address => mapping(uint256 => uint256)) public pendingTokenIdsIndexes;
    mapping(address => uint256[]) public receivedTokenIds;
    mapping(address => mapping(uint256 => uint256)) public receivedTokenIdsIndexes;
    mapping(uint256 => Letter) public letters;
    mapping(uint256 => Letter) public pendingLetters;

    event LetterSent(Letter letter);

    constructor() ERC721('Letters2Bffls', 'L2BFFL') Ownable() {}

    function send(address[] memory recipients, LetterData memory letterData) public {
        address sender = msg.sender;

        uint256 letterId = uint256(keccak256(abi.encodePacked(sender, block.timestamp, letterData.message)));

        Letter memory letter;
        letter.id = letterId;
        letter.sender = sender;
        letter.receivers = recipients;
        letter.timestamp = block.timestamp;
        letter.data = letterData;

        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 recipientTokenId = uint256(keccak256(abi.encodePacked(recipients[i], letterId)));

            pendingTokenIds[sender].push(recipientTokenId);
            pendingTokenIdsIndexes[sender][recipientTokenId] = pendingTokenIds[sender].length - 1;
            receivedTokenIds[recipients[i]].push(recipientTokenId);
            receivedTokenIdsIndexes[recipients[i]][recipientTokenId] = receivedTokenIds[recipients[i]].length - 1;

            Letter memory pendingLetter = letter;
            pendingLetter.receiver = recipients[i];
            pendingLetters[recipientTokenId] = pendingLetter;
        }

        emit LetterSent(letter);
    }

    function accept(uint256 tokenId) public {
        Letter memory letter = pendingLetters[tokenId];
        require(letter.receiver == msg.sender, 'Letter not addressed to you');

        delete pendingLetters[tokenId];

        uint256 pendingLetterIndex = pendingTokenIdsIndexes[letter.sender][tokenId];
        pendingTokenIds[letter.sender][pendingLetterIndex] = pendingTokenIds[letter.sender][
            pendingTokenIds[letter.sender].length - 1
        ];
        pendingTokenIds[letter.sender].pop();

        uint256 receivedLetterIndex = receivedTokenIdsIndexes[letter.receiver][tokenId];
        receivedTokenIds[letter.receiver][receivedLetterIndex] = receivedTokenIds[letter.receiver][
            receivedTokenIds[letter.receiver].length - 1
        ];
        receivedTokenIds[letter.receiver].pop();

        uint256 receiverTokenId = uint256(keccak256(abi.encodePacked(letter.receiver, tokenId)));
        letters[receiverTokenId] = letter;
        _safeMint(letter.receiver, receiverTokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        Letter memory letter = letters[tokenId];
        string memory receiver = utils.toString(abi.encodePacked(letter.receiver));
        string memory sender = utils.toString(abi.encodePacked(letter.sender));
        return renderer.render(receiver, sender, letter.data);
    }

    function setBaseURI(string memory uri) external onlyOwner {
        baseURI = uri;
    }
}
