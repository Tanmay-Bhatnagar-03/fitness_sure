// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FlappyBird is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    ERC721Pausable,
    Ownable
{
    uint256 private _nextTokenId;

    mapping(address => uint256[]) public userNfts;

    constructor(
        address initialOwner
    ) ERC721("FlappyBird", "FLAP") Ownable(initialOwner) {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        userNfts[msg.sender].push(tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
// pragma solidity ^0.8.19;

// // Uncomment this line to use console.log
// // import "hardhat/console.sol";

// contract FlappyBirdNFTs is ERC721Enumerable, Ownable {
//     /**
//      * @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
//      * token will be the concatenation of the `baseURI` and the `tokenId`.
//      */
//     string _baseTokenURI;

//     // _paused is used to pause the contract in case of an emergency
//     bool public _paused;

//     // total number of tokenIds minted
//     uint256 public tokenIds;

//     // map of nfts owned by a user
//     mapping(address => int[]) public userNfts;

//     modifier onlyWhenNotPaused() {
//         require(!_paused, "Contract currently paused");
//         _;
//     }

//     /**
//      * @dev ERC721 constructor takes in a `name` and a `symbol` to the token collection.
//      * It also initializes an instance of whitelist interface.
//      */
//     constructor() ERC721("FlappyBird", "FLAP") {
//         tokenIds = 0;
//     }

//     /**
//         @dev change token uri
//      */

//     function tokenURI(string memory data_uri) public view virtual returns (string memory) {
//         require(bytes(data_uri).length > 0, "ERC721Metadata: URI query for nonexistent token");
//         return string(abi.encodePacked(data_uri));
//     }

//     /**
//      * @dev mint allows a user to mint 1 NFT per transaction.
//      */
//     function mint() public payable onlyWhenNotPaused {
//         tokenIds += 1;
//         _safeMint(msg.sender, tokenIds);
//         userNfts[msg.sender].push(tokenIds);
//     }

//     /**
//      * @dev setPaused makes the contract paused or unpaused
//      */
//     function setPaused(bool val) public onlyOwner {
//         _paused = val;
//     }

//     /**
//      * @dev withdraw sends all the ether in the contract
//      * to the owner of the contract
//      */
//     function withdraw() public onlyOwner {
//         address _owner = owner();
//         uint256 amount = address(this).balance;
//         (bool sent, ) = _owner.call{value: amount}("");
//         require(sent, "Failed to send Ether");
//     }

//     // Function to receive Ether. msg.data must be empty
//     receive() external payable {}

//     // Fallback function is called when msg.data is not empty
//     fallback() external payable {}
// }
