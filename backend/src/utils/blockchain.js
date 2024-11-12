// src/utils/blockchain.js
const { ethers } = require("ethers");
const abi = require("../abis/RetirementWallet.json");
const provider = new ethers.providers.JsonRpcProvider(process.env.BASE_RPC_URL);

const contract = new ethers.Contract(
  process.env.CONTRACT_ADDRESS,
  abi,
  new ethers.Wallet(process.env.PRIVATE_KEY, provider)
);

const getUserBalance = async (address) => {
  try {
    const balance = await contract.getBalance(address);
    return ethers.utils.formatEther(balance);
  } catch (err) {
    console.error("Error fetching user balance:", err);
    throw new Error("Failed to retrieve user balance.");
  }
};

const deposit = async (amount) => {
  try {
    const tx = await contract.deposit({ value: ethers.utils.parseEther(amount) });
    await tx.wait();
  } catch (err) {
    console.error("Error performing deposit transaction:", err);
    throw new Error("Failed to complete deposit transaction.");
  }
};

module.exports = {
  getUserBalance,
  deposit,
};
