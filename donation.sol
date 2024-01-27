// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Donate {
    uint256 immutable goal;
    uint256 public progress;
    address immutable owner;

    
    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed owner, uint256 amount);

    constructor(uint256 _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier goalReached() {
        require(progress >= goal, "Goal not reached");
        _;
    }

    function deposit() external payable {
        require(msg.value >= 1 ether, "The minimum amount to send is 1 ether");
        progress += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner goalReached {
        uint256 balance = address(this).balance;
        payable(owner).transfer(balance);
        progress = 0;
        emit Withdrawal(owner, balance);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function isGoalReached() external view returns (bool) {
        return progress >= goal;
    }

    
}
