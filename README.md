

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
5. Android Setup

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
4.  **Testing Flow**:
   - Connect to either MetaMask or Coinbase Wallet configured for Base.
   - Deposit ETH, view balance, and perform a withdrawal.
   - Test trading by connecting to Uniswap.
   - Check API endpoints for hardship codes using Postman
   ---
   
 **Android**
With the files we've outlined, you have a foundational structure for the **Retirement Base Wallet** app. Here are a few additional files and configurations you might consider adding to ensure the project is complete, well-organized, and ready for future development and deployment.

### Additional Files for a Complete Android Project

---

#### 1. `settings.gradle`

The `settings.gradle` file is necessary for any Android project as it identifies which modules to include in the project build. 

**File**: `settings.gradle`

```gradle
include ':app'
rootProject.name = "RetirementBaseWallet"
```

---

#### 2. `.gitignore`

A `.gitignore` file helps to prevent sensitive files, environment configurations, and other unnecessary files from being committed to Git. 

**File**: `.gitignore`

```plaintext
# Android/IntelliJ
.gradle/
.idea/
build/
app/build/

# Keystore files
*.jks

# Gradle files
gradle.properties

# Android Studio generated files
captures/
.externalNativeBuild/
.cxx/
.localproperties

# Environment Variables
local.properties

# Logs and binaries
*.log
*.apk
*.ap_

# Node Modules (if any)
node_modules/
```

---

# Retirement Base Wallet

The **Retirement Base Wallet** is an Android application for secure cryptocurrency retirement savings. It enables users to connect with MetaMask or Coinbase Wallet, view balances, make deposits, and withdraw funds, and retrieve hardship codes securely.

## Features

- **Secure Wallet Connection**: MetaMask and Coinbase Wallet support using WalletConnect SDK.
- **Blockchain Interactions**: View balance, deposit, and withdraw via a secure connection with Web3j.
- **Hardship Codes**: Retrieve special hardship codes from the backend to facilitate penalty-free withdrawals when needed.

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/RetirementBaseWallet.git
   ```

2. Open the project in **Android Studio**.

3. Configure environment variables in `gradle.properties`:
   - Set `INFURA_PROJECT_ID`, `WALLET_CONNECT_CLIENT_ID`, and `WALLET_CONNECT_CLIENT_SECRET` as needed.

4. Run the app on an Android emulator or device.

For more details, see individual files and code comments.
```

---

#### 4. `local.properties`

This file holds local paths specific to your development environment, such as the SDK location. It should be automatically generated by Android Studio but can be created manually if needed.

**File**: `local.properties`

```properties
# SDK location
sdk.dir=/path/to/your/Android/Sdk
```

> **Note**: Do not commit this file to version control as it contains system-specific configurations.

