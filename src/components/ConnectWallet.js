// src/components/ConnectWallet.js
import React, { useState } from "react";
import { ethers } from "ethers";
import CoinbaseWalletSDK from "@coinbase/wallet-sdk";
import { CONTRACT_ADDRESS } from "../utils/constants";
import RetirementWalletABI from "../abis/RetirementWallet.json";

// Coinbase Wallet settings
const APP_NAME = "Retirement Base";
const APP_LOGO_URL = "https://example.com/logo.png"; // Replace with your logo URL
const DEFAULT_ETH_JSONRPC_URL = "https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID";
const DEFAULT_CHAIN_ID = 1; // Mainnet (for testing, consider using Ropsten or another testnet)

const ConnectWallet = ({ onConnected }) => {
  const [account, setAccount] = useState(null);

  const connectMetaMask = async () => {
    if (window.ethereum) {
      try {
        await window.ethereum.request({ method: "eth_requestAccounts" });
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const address = await signer.getAddress();
        setAccount(address);
        onConnected(signer);
      } catch (error) {
        console.error("Error connecting MetaMask:", error);
      }
    } else {
      alert("MetaMask is not installed!");
    }
  };

  const connectCoinbaseWallet = async () => {
    try {
      const coinbaseWallet = new CoinbaseWalletSDK({
        appName: APP_NAME,
        appLogoUrl: APP_LOGO_URL,
        darkMode: false
      });
      
      const ethereum = coinbaseWallet.makeWeb3Provider(DEFAULT_ETH_JSONRPC_URL, DEFAULT_CHAIN_ID);
      const provider = new ethers.providers.Web3Provider(ethereum);
      await ethereum.enable();
      const signer = provider.getSigner();
      const address = await signer.getAddress();
      setAccount(address);
      onConnected(signer);
    } catch (error) {
      console.error("Error connecting Coinbase Wallet:", error);
    }
  };

  return (
    <div>
      {account ? (
        <p>Connected as: {account}</p>
      ) : (
        <div>
          <button onClick={connectMetaMask}>Connect MetaMask</button>
          <button onClick={connectCoinbaseWallet}>Connect Coinbase Wallet</button>
        </div>
      )}
    </div>
  );
};

export default ConnectWallet;
