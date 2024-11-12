// src/components/Dashboard.js
import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import { CONTRACT_ADDRESS } from "../utils/constants";
import RetirementWalletABI from "../abis/RetirementWallet.json";

const Dashboard = ({ signer }) => {
  const [balance, setBalance] = useState("0.0");
  const [pnl, setPNL] = useState("0.0");

  useEffect(() => {
    const loadBalance = async () => {
      if (signer) {
        const contract = new ethers.Contract(CONTRACT_ADDRESS, RetirementWalletABI, signer);
        const userBalance = await contract.getBalance();
        setBalance(ethers.utils.formatEther(userBalance));
        setPNL("5.2%"); // Mock data for PNL
      }
    };
    loadBalance();
  }, [signer]);

  const depositFunds = async (amount) => {
    try {
      const tx = await signer.sendTransaction({
        to: CONTRACT_ADDRESS,
        value: ethers.utils.parseEther(amount),
      });
      await tx.wait();
      alert("Deposit successful!");
    } catch (error) {
      console.error("Error depositing funds:", error);
    }
  };

  const withdrawFunds = async (amount, hardshipCode = null) => {
    const contract = new ethers.Contract(CONTRACT_ADDRESS, RetirementWalletABI, signer);
    try {
      const tx = await contract.withdraw(ethers.utils.parseEther(amount), hardshipCode);
      await tx.wait();
      alert("Withdrawal successful!");
    } catch (error) {
      console.error("Error withdrawing funds:", error);
    }
  };

  return (
    <div>
      <header>
        <h2>Dashboard</h2>
        <div>Balance: {balance} ETH</div>
        <div>PNL: {pnl}</div>
      </header>
      <div>
        <button onClick={() => depositFunds("0.1")}>Deposit 0.1 ETH</button>
        <button onClick={() => withdrawFunds("0.1")}>Withdraw 0.1 ETH</button>
      </div>
    </div>
  );
};

export default Dashboard;
