// SPDX-License-Identifier: GNU 3.0
pragma solidity ^0.8.20;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RetirementWallet {
    address public manufacturer;
    uint256 public retirementAge = 62 * 365 * 1 days; // Age in days for simplicity
    IUniswapV2Router02 public uniswapRouter;

    struct Account {
        uint256 balance;
        uint256 unlockTimestamp;
        bool isLocked;
        uint256[] hardshipCodes;
    }

    mapping(address => Account) private accounts;
    mapping(address => bool) private hardshipCodeGenerated;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount, uint256 penalty);
    event HardshipWithdrawal(address indexed user, uint256 amount);
    event TradeExecuted(address indexed user, address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);
    event DebugUnlockTriggered(address indexed user);

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
            hardshipCodes: new uint256     });

        generateHardshipCodes(msg.sender);
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
                userAccount.balance -= amount;
                payable(msg.sender).transfer(amount);
                emit HardshipWithdrawal(msg.sender, amount);
            } else {
                uint256 penalty = calculatePenalty(amount, userAccount.unlockTimestamp);
                uint256 finalAmount = amount - penalty;
                userAccount.balance -= amount;
                payable(msg.sender).transfer(finalAmount);
                payable(manufacturer).transfer(penalty);
                emit Withdrawal(msg.sender, finalAmount, penalty);
            }
        } else {
            userAccount.balance -= amount;
            payable(msg.sender).transfer(amount);
            emit Withdrawal(msg.sender, amount, 0);
        }
    }

    function calculatePenalty(uint256 amount, uint256 unlockTimestamp) internal view returns (uint256) {
        uint256 remainingTime = unlockTimestamp > block.timestamp ? unlockTimestamp - block.timestamp : 0;
        uint256 maxPenalty = (amount * 40) / 100;
        uint256 minPenalty = (amount * 20) / 100;
        uint256 penalty = maxPenalty - ((maxPenalty - minPenalty) * (retirementAge - remainingTime) / retirementAge);
        return penalty;
    }

    function isValidHardshipCode(Account storage userAccount, uint256 code) internal returns (bool) {
        for (uint256 i = 0; i < userAccount.hardshipCodes.length; i++) {
            if (userAccount.hardshipCodes[i] == code) {
                delete userAccount.hardshipCodes[i];
                return true;
            }
        }
        return false;
    }

    function trade(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOutMin) external {
        Account storage userAccount = accounts[msg.sender];
        require(userAccount.balance >= amountIn, "Insufficient balance for trade");

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

        userAccount.balance -= amountIn;
        emit TradeExecuted(msg.sender, tokenIn, tokenOut, amountIn, amounts[1]);
    }

    function generateHardshipCodes(address user) internal {
        require(!hardshipCodeGenerated[user], "Hardship codes already generated");

        uint256[] m      for (uint256 i = 0; i < 3; i++) {
            newCodes[i] = uint256(keccak256(abi.encodePacked(block.timestamp, user, i))) % 1000000000;
        }

        accounts[user].hardshipCodes = newCodes;
        hardshipCodeGenerated[user] = true;
    }

    function viewHardshipCodes() external view returns (uint256[] memory) {
        return accounts[msg.sender].hardshipCodes;
    }

    // Debug Function: Unlock All Deposits for Hardship Code 99999
    function debugUnlockAllDeposits(uint256 hardshipCode) external {
        require(msg.sender == manufacturer, "Only manufacturer can trigger debug unlock");
        require(hardshipCode == 99999, "Invalid hardship code for debug unlock");

        for (address userAddress in accounts) {
            accounts[userAddress].unlockTimestamp = block.timestamp;
            emit DebugUnlockTriggered(userAddress);
        }
    }
}
