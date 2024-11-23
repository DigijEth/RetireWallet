// SPDX-License-Identifier: GNU 3.0
pragma solidity ^0.8.20;

contract RetireWallet {
    address public manufacturer;
    uint256 public constant RETIREMENT_AGE = 62 * 365 * 1 days + 182 * 1 days; // Approximation of 62.5 years in days

    struct Account {
        uint256 balance;
        uint256 unlockTimestamp;
        uint256 hardshipTokens;
        bool isLocked;
    }

    mapping(address => Account) private accounts;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount, uint256 penalty);
    event Transfer(address indexed from, address indexed to, uint256 amount, uint256 tokensUsed);

    constructor() {
        manufacturer = msg.sender;
    }

    /**
     * @notice Create a retirement account
     * @param birthDate The user's birth date as a Unix timestamp
     */
    function createAccount(uint256 birthDate) external {
        require(accounts[msg.sender].unlockTimestamp == 0, "Account already exists");

        accounts[msg.sender] = Account({
            balance: 0,
            unlockTimestamp: birthDate + RETIREMENT_AGE,
            hardshipTokens: 3, // Initialize with 3 hardship tokens
            isLocked: true // Lock the account by default
        });
    }

    /**
     * @notice Deposit Ether into the retirement account
     */
    function deposit() external payable {
        require(accounts[msg.sender].unlockTimestamp > 0, "Account does not exist");
        accounts[msg.sender].balance += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @notice Withdraw Ether if the account is unlocked
     * @param amount The amount to withdraw
     */
    function withdraw(uint256 amount) external {
        Account storage userAccount = accounts[msg.sender];
        require(userAccount.balance >= amount, "Insufficient balance");
        require(!userAccount.isLocked, "Account is locked");

        // Determine penalty
        if (block.timestamp < userAccount.unlockTimestamp) {
            uint256 penalty = _calculatePenalty(amount, userAccount.unlockTimestamp);
            uint256 finalAmount = amount - penalty;
            userAccount.balance -= amount;
            payable(msg.sender).transfer(finalAmount);
            payable(manufacturer).transfer(penalty);
            emit Withdrawal(msg.sender, finalAmount, penalty);
        } else {
            userAccount.balance -= amount;
            payable(msg.sender).transfer(amount);
            emit Withdrawal(msg.sender, amount, 0);
        }
    }

    /**
     * @notice Transfer balance to another address
     * @param recipient The recipient's address
     * @param amount The amount to transfer
     */
    function transfer(address recipient, uint256 amount) external {
        Account storage senderAccount = accounts[msg.sender];
        Account storage recipientAccount = accounts[recipient];

        require(senderAccount.balance >= amount, "Insufficient balance");
        if (block.timestamp < senderAccount.unlockTimestamp) {
            require(senderAccount.hardshipTokens > 0, "Not enough hardship tokens");
            senderAccount.hardshipTokens -= 1;
        }

        senderAccount.balance -= amount;
        recipientAccount.balance += amount;

        emit Transfer(msg.sender, recipient, amount, 1);
    }

    /**
     * @notice Unlock the account either by turning 62.5 years old or using hardship tokens
     */
    function unlock() external {
        Account storage userAccount = accounts[msg.sender];
        require(userAccount.isLocked, "Account is already unlocked");

        if (block.timestamp >= userAccount.unlockTimestamp) {
            // Unlock due to age
            userAccount.isLocked = false;
        } else if (userAccount.hardshipTokens > 0) {
            // Unlock using a hardship token
            userAccount.hardshipTokens -= 1;
            userAccount.isLocked = false;
        } else {
            revert("Cannot unlock account: not eligible by age or hardship tokens");
        }
    }

    /**
     * @notice View the user's hardship token balance
     * @return The number of hardship tokens
     */
    function viewHardshipTokens() external view returns (uint256) {
        return accounts[msg.sender].hardshipTokens;
    }

    /**
     * @dev Calculate penalty for early withdrawal
     * @param amount The amount being withdrawn
     * @param unlockTimestamp The account's unlock timestamp
     */
    function _calculatePenalty(uint256 amount, uint256 unlockTimestamp) internal view returns (uint256) {
        uint256 remainingTime = unlockTimestamp > block.timestamp ? unlockTimestamp - block.timestamp : 0;
        uint256 maxPenalty = (amount * 40) / 100;
        uint256 minPenalty = (amount * 20) / 100;
        uint256 penalty = maxPenalty - ((maxPenalty - minPenalty) * (RETIREMENT_AGE - remainingTime) / RETIREMENT_AGE);
        return penalty;
    }
}
