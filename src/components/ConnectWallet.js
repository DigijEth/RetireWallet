import React, { useState } from "react";
import { ethers } from "ethers";
import CoinbaseWalletSDK from "@coinbase/wallet-sdk";
import { Alert, Snackbar } from "@mui/material";

const APP_NAME = "Retirement Base";
const APP_LOGO_URL = "https://example.com/logo.png";
const DEFAULT_ETH_JSONRPC_URL = process.env.REACT_APP_BASE_RPC_URL;
const DEFAULT_CHAIN_ID = 8453; // Base Mainnet

const ConnectWallet = ({ onConnected }) => {
  const [account, setAccount] = useState(null);
  const [error, setError] = useState(null);

  const handleError = (message) => {
    setError(message);
    setTimeout(() => setError(null), 5000); // Auto-clear error after 5 seconds
  };

  const connectMetaMask = async () => {
    if (window.ethereum) {
      try {
        await window.ethereum.request({ method: "eth_requestAccounts" });
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const address = await signer.getAddress();
        setAccount(address);
        onConnected(signer);
      } catch (err) {
        handleError("Failed to connect MetaMask. Please try again.");
        console.error("MetaMask connection error:", err);
      }
    } else {
      handleError("MetaMask is not installed!");
    }
  };

  const connectCoinbaseWallet = async () => {
    try {
      const coinbaseWallet = new CoinbaseWalletSDK({
        appName: APP_NAME,
        appLogoUrl: APP_LOGO_URL,
        darkMode: false,
      });

      const ethereum = coinbaseWallet.makeWeb3Provider(DEFAULT_ETH_JSONRPC_URL, DEFAULT_CHAIN_ID);
      const provider = new ethers.providers.Web3Provider(ethereum);
      await ethereum.enable();
      const signer = provider.getSigner();
      const address = await signer.getAddress();
      setAccount(address);
      onConnected(signer);
    } catch (err) {
      handleError("Failed to connect Coinbase Wallet. Please try again.");
      console.error("Coinbase Wallet connection error:", err);
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
      {error && (
        <Snackbar open={Boolean(error)} autoHideDuration={6000}>
          <Alert severity="error">{error}</Alert>
        </Snackbar>
      )}
    </div>
  );
};

export default ConnectWallet;
