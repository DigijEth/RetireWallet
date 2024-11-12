// SPDX-License-Identifier: GNU 3.0
pragma solidity ^0.8.0;

contract RetirementWallet {
    address public manufacturer;
    uint256 public retirementAge = 62 * 365 * 1 days; // Age in days for simplicity

    struct Account {
        uint256 balance;
        uint256 unlockTimestamp;
        bool isLocked;
        uint256[] hardshipCodes;
    }

    mapping(address => Account) private accounts;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount, uint256 penalty);
    event HardshipWithdrawal(address indexed user, uint256 amount);

    constructor() {
        manufacturer = msg.sender; // Set manufacturer as the deployer of the contract
    }

    function createAccount(uint256 birthDate) external {
        require(accounts[msg.sender].unlockTimestamp == 0, "Account already exists");

        accounts[msg.sender] = Account({
            balance: 0,
            unlockTimestamp: birthDate + retirementAge,
            isLocked: true,
            hardshipCodes: new uint256Generate 3 hardship codes as needed
        });
    }

    function deposit() external payable {
        require(accounts[msg.sender].unlockTimestamp > 0, "Account does not exist");
        accounts[msg.sender].balance += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount, uint256 hardshipCode) external {
        Account storage userAccount = accounts[msg.sender];
        require(userAccount.balance >= amount, "Insufficient balance");
        
        if (block.timestamp < userAccount.unlockTimestamp) {
            if (isValidHardshipCode(userAccount, hardshipCode)) {
                // Hardship withdrawal, no penalty
                userAccount.balance -= amount;
                payable(msg.sender).transfer(amount);
                emit HardshipWithdrawal(msg.sender, amount);
            } else {
                // Early withdrawal with penalty
                uint256 penalty = calculatePenalty(amount);
                uint256 finalAmount = amount - penalty;
                userAccount.balance -= amount;
                payable(msg.sender).transfer(finalAmount);
                payable(manufacturer).transfer(penalty);
                emit Withdrawal(msg.sender, finalAmount, penalty);
            }
        } else {
            // Retirement withdrawal, no penalty
            userAccount.balance -= amount;
            payable(msg.sender).transfer(amount);
            emit Withdrawal(msg.sender, amount, 0);
        }
    }

    function calculatePenalty(uint256 amount) internal view returns (uint256) {
        // Implement a 20-40% penalty calculation based on user’s remaining time to retirement
        return (amount * 30) / 100; // Example 30% penalty, adjustable as needed
    }

    function isValidHardshipCode(Account storage userAccount, uint256 code) internal returns (bool) {
        // Verify if the hardship code is valid
        for (uint i = 0; i < userAccount.hardshipCodes.length; i++) {
            if (userAccount.hardshipCodes[i] == code) {
                // Invalidate the used code
                delete userAccount.hardshipCodes[i];
                return true;
            }
        }
        return false;
    }
}

