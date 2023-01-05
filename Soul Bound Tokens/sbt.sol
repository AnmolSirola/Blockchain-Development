// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7 ;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract UniversityDegree is ERC721URIStorage {

  address owner ;
  
  using Counters for Counters.Counter ;
  Counters.Counter private tokenIds;

  constructor() ERC721("UniversityDegree" , "Degree"){
    owner = msg.sender ;
  }

  mapping(address => bool) public issuedDegree ;

  modifier onlyOwner() {
      require(msg.sender == owner);
      _;
  }

  function issueDegree(address to) external onlyOwner {
     issuedDegree[to] = true;
  }

  function claimDegree(string memory tokenURI) public returns(uint256){
     require(issuedDegree[msg.sender] , "Degree is not issued");

     tokenIds.increment();
     uint256 newItemId = tokenIds.current();
     _mint(msg.sender , newItemId);
     _setTokenURI(newItemId , tokenURI);
     
     personToDegree[msg.sender] = tokenURI;
     issuedDegree[msg.sender] = false ;

     return newItemId;
      
  }

  mapping(address => string) public personToDegree ;

  bool cannotTransfer = true;

  function safeTransferFrom(address _from, address _to, uint256 _tokenId) public virtual override {
      require(cannotTransfer == false, "You cannot transfer this NFT.");
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) public virtual override {
      require(cannotTransfer == false, "You cannot transfer this NFT.");
  }

  function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public virtual override {
      require(cannotTransfer == false, "You cannot transfer this NFT.");
  }

}
