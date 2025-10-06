// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// This contract is used to prove that a document existed at a certain time.
// We can do that by storing its hash permanently on the blockchain.
contract ProofOfExistence {
    // The person who deployed the contract (owner)
    address public owner;

    // This keeps track of every document hash and the time it was stored
    mapping(bytes32 => uint256) public proofs;

    // This event is called whenever someone notarizes a document
    event DocumentNotarized(address indexed who, bytes32 indexed docHash, uint256 timestamp);

    // When the contract is deployed, set the deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    // This function saves the hash of a document by notarized it
    function notarizeDocument(bytes32 _documentHash) public {
        require(_documentHash != bytes32(0), "Empty hash not allowed"); // can’t be empty
        require(proofs[_documentHash] == 0, "Document already notarized"); // can’t be reused
        proofs[_documentHash] = block.timestamp; // store the time it was submitted
        emit DocumentNotarized(msg.sender, _documentHash, block.timestamp); // let everyone know it worked
    }

    // This checks if a document has already been notarized
    function verifyDocument(bytes32 _documentHash) public view returns (bool) {
        return proofs[_documentHash] != 0; // if there’s a timestamp, it exists
    }

    // These let the contract safely receive Ether, even if we don’t use it
    receive() external payable {}
    fallback() external payable {}
}
