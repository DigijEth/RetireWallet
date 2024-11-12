

---

# The Retirement Base Wallet

The Retirement Base Wallet is a decentralized, multi-chain crypto retirement wallet on the **Base** blockchain. It enforces a lock-in period to encourage long-term savings. Users can deposit crypto assets into a retirement contract, trade within the app, and access funds only after reaching retirement age (62 1/2) or via hardship withdrawals when required. This project integrates with Coinbase Wallet and MetaMask for versatile wallet support.

---

## Table of Contents

1. [Overview](#overview)
2. [To-Do List](#to-do-list)
3. [Setup Instructions](#setup-instructions)
   - [Smart Contract](#smart-contract)
   - [Backend](#backend)
   - [Frontend](#frontend)
4. [Testing the App](#testing-the-app)

---

## Overview

**The Retirement Base Wallet** is designed to act as a crypto retirement fund, where users can deposit assets and trade within the app while keeping their funds secure until a specified retirement age. Key features include:

- **Lock-In Functionality**: Funds are locked until the user reaches retirement age, with an option for penalty-free hardship withdrawals.
- **Multiple Wallet Support**: Connect via MetaMask and Coinbase Wallet.
- **Uniswap Integration**: Trade supported assets within the app.
- **Backend API**: Manage hardship codes, user balances, and contract interactions.

The Retirement Base Wallet provides a foundation for a secure, decentralized retirement savings experience in the world of cryptocurrency.

---

## To-Do List

### Planned Features

- **Staking**: Allow users to earn rewards by staking their retirement funds.
- **Pooling**: Provide options to invest in pools with other users for diversified investments.
- **The Retire Coin**: Introduce a native token that offers exclusive benefits, such as reduced fees or staking bonuses.
- **Advanced Security**: Implement two-factor authentication and security alerts for added account safety.
- **User-Friendly Dashboard**: Improve the user interface with portfolio analytics, progress tracking, and personalized insights.
- **Liquidity Provision**: Allow users to contribute to liquidity pools for additional earnings.
- **Enhanced Smart Contract Functionality**: Support more DeFi features and protocols, such as lending and borrowing.
- **Extended Wallet Integrations**: Add support for additional wallets (e.g., WalletConnect, Trust Wallet).

### Current Features

- **Smart Contract**: Base blockchain smart contract for locking funds, supporting withdrawals, and trading.
- **Backend API**: Securely stores hardship codes, user balances, and manages blockchain interactions.
- **Frontend**: React app with wallet connection, Uniswap trading, and balance display.

---

## Setup Instructions

### Prerequisites

Ensure you have the following installed:
- **Node.js** and **npm**
- **MetaMask** and **Coinbase Wallet** (browser extension or app)
- **MongoDB** (for backend data storage)
- **Infura or Alchemy Project ID** configured for the Base network

---

### 1. Smart Contract

#### a) Contract Code (`Contract/retire.sol`)

The smart contract is located in the `Contract/` directory. It includes:
- **Lock-In Mechanism**: Locks funds until the user reaches the defined retirement age.
- **Hardship Withdrawals**: Allows penalty-free withdrawals with hardship codes.
- **Uniswap Integration**: Enables trading within the retirement wallet.

#### b) Compilation and Deployment on Base

1. Compile the smart contract using **Remix** or **Hardhat** configured for the Base network.
2. Deploy the contract on Base using your preferred deployment tool.
3. Copy the contract address and ABI, as you’ll need them for both the frontend and backend setups.

---

### 2. Backend

The backend is responsible for managing user data, generating hardship codes, and providing APIs for the frontend to interact with the smart contract.

#### a) Directory Structure

```plaintext
backend/
├── src/
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   ├── utils/
│   ├── app.js
│   ├── server.js
│   └── abis/
└── .env
```

#### b) Configuration

1. **Environment Variables**:
   - Create a `.env` file in the `backend` folder with the following variables:

     ```plaintext
     MONGO_URI=mongodb://localhost:27017/retirementBase
     PRIVATE_KEY="your-private-key"
     CONTRACT_ADDRESS="0xYourContractAddress"
     BASE_RPC_URL="https://base-mainnet.infura.io/v3/your-infura-project-id"
     PORT=5000
     ```

2. **Install Dependencies**:

   ```bash
   cd backend
   npm install express mongoose dotenv ethers jsonwebtoken bcryptjs
   ```

#### c) MongoDB Model

The `User` model stores each user’s address, balance, and hardship codes. It’s located in `src/models/User.js`.

#### d) Blockchain Utilities for Base

`src/utils/blockchain.js` uses ethers.js to interact with the contract functions like `getBalance`, `deposit`, and `withdraw`.

#### e) API Endpoints

The backend provides endpoints to manage hardship codes:
- `GET /api/hardship/:address`: Retrieve hardship codes.
- `POST /api/hardship`: Generate new hardship codes.

#### f) Start the Server

To start the backend server:

```bash
node src/server.js
```

---

### 3. Frontend

The frontend is a React application that connects to the smart contract and backend to allow users to view balances, deposit funds, trade, and manage hardship withdrawals.

#### a) Directory Structure

```plaintext
frontend/
├── src/
│   ├── components/
│   ├── abis/
│   ├── utils/
│   ├── App.js
│   └── index.js
└── public/
```

#### b) Configuration

1. Place the **ABI** file (`RetirementWallet.json`) in `src/abis/`.
2. Set up constants in `src/utils/constants.js`:

   ```javascript
   export const CONTRACT_ADDRESS = "0xYourContractAddress";
   export const BASE_RPC_URL = "https://base-mainnet.infura.io/v3/your-infura-project-id";
   ```

3. **Install Dependencies**:

   ```bash
   cd frontend
   npm install ethers @coinbase/wallet-sdk @mui/material @emotion/react @emotion/styled
   ```

#### c) Key Components

1. **ConnectWallet.js**: Handles wallet connections for MetaMask and Coinbase Wallet.
2. **Dashboard.js**: Displays user balance, allows deposits/withdrawals, and integrates Uniswap for trading.
3. **App.js**: Main component that controls connection states and renders the `Dashboard`.

#### d) Start the Frontend

```bash
npm start
```

---

## Testing the App

1. **Start MongoDB**:
   ```bash
   mongod
   ```

2. **Start Backend Server**:
   ```bash
   cd backend
   node src/server.js
   ```

3. **Start Frontend**:
   ```bash
   cd frontend
   npm start
   ```

4. **Testing Flow**:
   - Connect to either MetaMask or Coinbase Wallet configured for Base.
   - Deposit ETH, view balance, and perform a withdrawal.
   - Test trading by connecting to Uniswap.
   - Check API endpoints for hardship codes using Postman.
