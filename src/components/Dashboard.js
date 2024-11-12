import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import { CONTRACT_ADDRESS } from "../utils/constants";
import RetirementWalletABI from "../abis/RetirementWallet.json";
import { Button, CircularProgress, Snackbar, Alert } from "@mui/material";

const Dashboard = ({ signer }) => {
  const [balance, setBalance] = useState("0.0");
  const [pnl, setPNL] = useState("0.0");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleError = (message) => {
    setError(message);
    setTimeout(() => setError(null), 5000); // Auto-clear error after 5 seconds
  };

  useEffect(() => {
    const loadBalance = async () => {
      try {
        const contract = new ethers.Contract(CONTRACT_ADDRESS, RetirementWalletABI, signer);
        const userBalance = await contract.getBalance();
        setBalance(ethers.utils.formatEther(userBalance));
        setPNL("5.2%"); // Mock data for PNL
      } catch (err) {
        handleError("Failed to load balance. Please try again.");
        console.error("Error loading balance:", err);
      }
    };

    if (signer) {
      loadBalance();
    }
  }, [signer]);

  const depositFunds = async (amount) => {
    setLoading(true);
    try {
      const contract = new ethers.Contract(CONTRACT_ADDRESS, RetirementWalletABI, signer);
      const tx = await contract.deposit({ value: ethers.utils.parseEther(amount) });
      await tx.wait();
      alert("Deposit successful!");
    } catch (err) {
      handleError("Failed to deposit funds. Please check your balance or try again.");
      console.error("Error depositing funds:", err);
    } finally {
      setLoading(false);
    }
  };

  const withdrawFunds = async (amount, hardshipCode = null) => {
    setLoading(true);
    try {
      const contract = new ethers.Contract(CONTRACT_ADDRESS, RetirementWalletABI, signer);
      const tx = await contract.withdraw(ethers.utils.parseEther(amount), hardshipCode);
      await tx.wait();
      alert("Withdrawal successful!");
    } catch (err) {
      handleError("Failed to withdraw funds. Please check your balance or try again.");
      console.error("Error withdrawing funds:", err);
    } finally {
      setLoading(false);
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
        <Button
          onClick={() => depositFunds("0.1")}
          variant="contained"
          color="primary"
          disabled={loading}
        >
          {loading ? <CircularProgress size={24} /> : "Deposit 0.1 ETH"}
        </Button>
        <Button
          onClick={() => withdrawFunds("0.1")}
          variant="contained"
          color="secondary"
          disabled={loading}
        >
          {loading ? <CircularProgress size={24} /> : "Withdraw 0.1 ETH"}
        </Button>
      </div>
      {error && (
        <Snackbar open={Boolean(error)} autoHideDuration={6000}>
          <Alert severity="error">{error}</Alert>
        </Snackbar>
      )}
    </div>
  );
};

export default Dashboard;
