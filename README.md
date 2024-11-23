
# Retirement Base Wallet

## About

The **Retirement Base Wallet** is a decentralized, multi-chain retirement crypto wallet designed to help users save for the long term. Built on the Base blockchain, it enables users to deposit crypto assets securely, interact with smart contracts for deposits and withdrawals, and access hardship codes for penalty-free early withdrawals. The wallet supports MetaMask and Coinbase Wallet for connection, allowing users to manage their retirement funds directly from their mobile devices.

**Donation:** Support our project by sending donations to:
- **Ethereum**: `digij.eth`
- **Base**: `digij.base.eth`

**Join Us**

If you are interested in contributing, please send and email to bradytheking17@gmail.com

---

## Features

- **Secure Wallet Connection**: Supports MetaMask and Coinbase Wallet, connected via WalletConnect SDK for secure authentication.
- **Blockchain Interactions**: Uses Web3j to interact with the Base smart contract, allowing users to deposit, view balances, and withdraw funds securely.
- **Hardship Codes**: Access hardship codes through a backend API to make penalty-free withdrawals in case of emergencies.
- **Comprehensive Security**: Manages sensitive environment variables and transactions securely, with error handling and secure API integrations.

---

## To-Do List

- **Staking**: Implement staking features for users to earn rewards on their retirement funds.
- **Pooling**: Enable investment pooling to allow for diversified investments with other users.
- **The Retire Coin**: Introduce a native token offering benefits like reduced fees and staking bonuses.
- **Extended Wallet Support**: Integrate additional wallet providers such as WalletConnect and Trust Wallet.
- **Advanced Security**: Add two-factor authentication (2FA) and security alerts.
- **Improved UI**: Enhance the user interface for a better user experience.
- **Analytics Dashboard**: Display portfolio analytics, tracking, and insights on user funds.
- **Liquidity Provision**: Allow users to contribute to liquidity pools and earn additional rewards.

---

## Setup Instructions

Below are detailed instructions for setting up each component of the **Retirement Base Wallet** project.

---

### Server

The backend server is responsible for managing user data, generating hardship codes, interacting with the smart contract, and providing secure API endpoints for the Android app.

#### Requirements

- **Node.js** and **npm**
- **MongoDB**
- **Infura Project ID** (configured for the Base network)
  
#### Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone https://github.com/DigiJEth/RetireWallet.git
   cd RetireWallet/server
   ```

2. **Environment Variables**
   Create a `.env` file in the `server` directory with the following contents:
   ```plaintext
   MONGO_URI=mongodb://localhost:27017/retirementBase
   PRIVATE_KEY="your-private-key"
   CONTRACT_ADDRESS="0xYourContractAddress"
   INFURA_PROJECT_ID="your-infura-project-id"
   PORT=5000
   ```

3. **Install Dependencies**
   ```bash
   npm install
   ```

4. **Run the Server**
   Start MongoDB, then start the server:
   ```bash
   mongod
   node src/server.js
   ```

#### Key API Endpoints

- **GET /api/hardship/:address** - Retrieve hardship codes.
- **POST /api/hardship** - Generate new hardship codes.

---

### Android App

The Android app allows users to connect their wallets, view their balances, and manage their retirement funds securely.

#### Requirements

- **Android Studio**
- **Kotlin** (already configured with Android Studio)
- **Infura Project ID**
  
#### Setup Instructions

1. **Open the Android Project**
   Open `RetirementBaseWallet/app` in Android Studio.

2. **Configure Environment Variables**
   In `gradle.properties`, add the following values:
   ```properties
   INFURA_PROJECT_ID=your_infura_project_id
   WALLET_CONNECT_CLIENT_ID=your_wallet_connect_client_id
   WALLET_CONNECT_CLIENT_SECRET=your_wallet_connect_client_secret
   ```

3. **Run the App**
   - Connect an Android device or start an emulator.
   - Click **Run** in Android Studio to build and deploy the app.

#### Key Features

- **MainActivity**: Wallet connection options (MetaMask, Coinbase Wallet).
- **DashboardActivity**: Balance display, deposit, and withdraw.
- **HardshipCodesActivity**: Retrieve hardship codes via backend API.

---

### Web Frontend

A web-based frontend will be added to allow users to access their wallet via a browser, similar to the Android app functionality.

#### Requirements

- **React**
- **Web3.js** for blockchain interactions
- **Axios** for API requests
  
#### Setup Instructions

1. **Initialize a React Project**
   Navigate to the frontend directory and initialize the project:
   ```bash
   cd RetirementBaseWallet/frontend
   npx create-react-app .
   ```

2. **Install Dependencies**
   ```bash
   npm install web3 axios
   ```

3. **Configure Environment Variables**
   In a `.env` file, add your Infura project ID:
   ```plaintext
   REACT_APP_INFURA_PROJECT_ID=your_infura_project_id
   ```

4. **Run the Frontend**
   ```bash
   npm start
   ```

#### Planned Features

- **Wallet Connection**: Allow users to connect MetaMask and Coinbase Wallet.
- **Dashboard**: Display balance and main actions (deposit, withdraw, view hardship codes).
- **Transaction History**: Show past deposits and withdrawals.

---

### Backend

The backend API provides secure data management and contract interaction for user data, hardship codes, and more.

#### Requirements

- **Node.js** and **Express.js**
- **MongoDB** for storing user information
- **Web3.js** or **ethers.js** for blockchain interaction
  
#### Setup Instructions

1. **Environment Variables**
   Make sure you have a `.env` file with:
   ```plaintext
   MONGO_URI=mongodb://localhost:27017/retirementBase
   PRIVATE_KEY="your-private-key"
   CONTRACT_ADDRESS="0xYourContractAddress"
   INFURA_PROJECT_ID="your-infura-project-id"
   ```

2. **Install Dependencies**
   ```bash
   npm install express mongoose dotenv web3 axios
   ```

3. **Start the Backend**
   ```bash
   node src/app.js
   ```

#### API Endpoints and Usage

- **GET /api/hardship/:address** - Retrieve hardship codes for a user.
- **POST /api/hardship** - Generate new hardship codes when requested.

This README should give you everything you need to set up, develop, and deploy **Retirement Base Wallet**. For further assistance, please refer to the documentation for Web3, WalletConnect, and Android SDKs as needed.

Thank you for supporting secure and decentralized finance.
