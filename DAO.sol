// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GaslessDAO is Ownable {
    IERC20 public token; // The ERC-20 token used by the DAO

    mapping(address => uint256) public nonces;

    event VoteCasted(address indexed voter, uint256 proposalId);

    constructor(address _token) {
        token = IERC20(_token);
    }

    function vote(uint256 proposalId, bytes calldata signature) external {
        address signer = recoverSigner(proposalId, signature);
        require(signer != address(0), "Invalid signature");

        // Ensure the signer has enough voting power in the DAO
        uint256 votingPower = token.balanceOf(signer);
        require(votingPower > 0, "Insufficient voting power");

        // Perform the DAO voting logic here...

        emit VoteCasted(signer, proposalId);
    }

    function executeTransaction(address to, uint256 value, bytes calldata data) external onlyOwner {
        // Execute transactions on behalf of the DAO (e.g., proposal execution)
        (bool success, ) = to.call{value: value}(data);
        require(success, "Transaction execution failed");
    }

    function recoverSigner(uint256 proposalId, bytes calldata signature) internal view returns (address) {
        bytes32 messageHash = keccak256(abi.encodePacked(address(this), msg.sender, proposalId, nonces[msg.sender]));
        nonces[msg.sender]++;
        return ecrecover(messageHash, uint8(signature[0]), bytes32(signature[1:33]), bytes32(signature[33:65]));
    }
}
