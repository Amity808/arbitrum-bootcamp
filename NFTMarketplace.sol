// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplaceV1 is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenId; // tokenId
    Counters.Counter  private _soldItems; // total items
    address payable owner;
    mapping (uint256 => NFTMarketplace) public nfts;

    // nft struct
     struct NFTMarketplace {
        address owner;
        address seller;
        uint256 price;
        bool sold;
        uint256 tokenId;
    }


    event NFT_Action(
        uint256 indexed  tokenId,
        address owner,
        address seller,
        uint256 price,
        bool sold,
        string message
    );


    constructor() ERC721("CeloNFT", "ASG"){
        owner = payable(msg.sender);
    }

    modifier checkNFT(uint tokenId) {
        require(_ownerOf(tokenId) != address(0), "NFT with specified tokenId doesn't exist.");
        _;
    }


    function createToken(string memory _tokenURI, uint256 price) external returns(uint256) {
        uint256 currentTokenId = _tokenId.current(); 
        _tokenId.increment();
        _mint(msg.sender,currentTokenId);
        _setTokenURI(currentTokenId,_tokenURI);
        createNFT(currentTokenId,price);
        return currentTokenId;
    }

     function createNFT(uint256 tokenId, uint256 price) internal {
        uint256 currentTokenId = _tokenId.current();
        nfts[currentTokenId] = NFTMarketplace(
            payable(address(this)),
            payable(msg.sender),
            price,
            false,
            tokenId
        );
        _transfer(msg.sender,address(this),tokenId);

        emit NFT_Action(
            tokenId,
            address(this),
            msg.sender,
            price,
            false,
            "NFT created successfuly"
        );

    }

    
    function sellNFT(uint256 tokenId) external payable checkNFT(tokenId) {
        require(!nfts[tokenId].sold, "NFT is sold");
        uint256 _price = nfts[tokenId].price;
        address seller = nfts[tokenId].seller;
        require(msg.value == _price, "incorrect amount");
        nfts[tokenId].owner = payable(msg.sender);
        nfts[tokenId].seller = payable(address(0)); 
        nfts[tokenId].sold = true;
        _soldItems.increment();

        (bool success,) = payable(seller).call{value : msg.value}(""); // make payment to seller
        require(success, "payment failed");
        _transfer(address(this),msg.sender,tokenId); // transfer ownership to sender

        emit NFT_Action(
            tokenId,
            msg.sender,
            address(0),
            _price,
            true,
            "Sold NFT successfully"
        );
    }

    
    function allNfts() external view returns (NFTMarketplace[] memory) {
        uint currentTokenId = _tokenId.current();
        NFTMarketplace[] memory items = new NFTMarketplace[](currentTokenId);
        for (uint i = 0; i < items.length; i++) {
            items[i] = nfts[i];
        }

        return items;
    }

   
    function getNFT(uint256 tokenId) external view checkNFT(tokenId) returns(NFTMarketplace memory __nft){
        __nft = nfts[tokenId];
        return __nft;
    }

    function getNftPrice(uint256 tokenId) external view checkNFT(tokenId) returns(uint256){
        return nfts[tokenId].price;
    }

    function userNfts() external view returns (NFTMarketplace[] memory) {
    uint currentTokenId = _tokenId.current();
    uint itemCount = 0;

    for (uint i = 0; i < currentTokenId; i++) {
        if (nfts[i].owner == msg.sender) {
            itemCount++;
        }
    }

    NFTMarketplace[] memory items = new NFTMarketplace[](itemCount);
    itemCount = 0;

    for (uint i = 0; i < currentTokenId; i++) {
        if (nfts[i].owner == msg.sender) {
            items[itemCount] = nfts[i];
            itemCount++;
        }
    }

    return items;
}



}
