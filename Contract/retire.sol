// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RetirementWallet {
    address public manufacturer;
    uint256 public retirementAge = 62 * 365 * 1 days; // Age in days for simplicity
    IUniswapV2Router02 public uniswapRouter; // Uniswap router for swapping tokens

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
    event TradeExecuted(address indexed user, address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);

    constructor(address _uniswapRouter) {
        manufacturer = msg.sender; // Set manufacturer as the deployer of the contract
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);
    }

    function createAccount(uint256 birthDate) external {
        require(accounts[msg.sender].unlockTimestamp == 0, "Account already exists");

        accounts[msg.sender] = Account({
            balance: 0,
            unlockTimestamp: birthDate + retirementAge,
            isLocked: true,
            hardshipCodes: new uint256 Placeholder, implement code generation
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
                uint256 penalty = calculatePenalty(amount, userAccount.unlockTimestamp);
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

    function calculatePenalty(uint256 amount, uint256 unlockTimestamp) internal view returns (uint256) {
        uint256 remainingTime = unlockTimestamp - block.timestamp;
        uint256 maxPenalty = (amount * 40) / 100; // 40% maximum penalty
        uint256 minPenalty = (amount * 20) / 100; // 20% minimum penalty

        // Penalty decreases as unlock date approaches
        uint256 penalty = maxPenalty - ((maxPenalty - minPenalty) * (retirementAge - remainingTime) / retirementAge);
        return penalty;
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

    function trade(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOutMin) external {
        Account storage userAccount = accounts[msg.sender];
        require(userAccount.balance >= amountIn, "Insufficient balance for trade");

        // Approve the Uniswap router to spend the token
        IERC20(tokenIn).approve(address(uniswapRouter), amountIn);

        address[] m      path[0] = tokenIn;
        path[1] = tokenOut;

        uint256[] memory amounts = uniswapRouter.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            address(this),
            block.timestamp
        );

        userAccount.balance -= amountIn; // Deduct the traded amount
        emit TradeExecuted(msg.sender, tokenIn, tokenOut, amountIn, amounts[1]);
    }
}
