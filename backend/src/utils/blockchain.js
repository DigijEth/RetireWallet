// src/utils/blockchain.js
const { ethers } = require("ethers");
const abi = require("../abis/RetirementWallet.json");
const provider = new ethers.providers.JsonRpcProvider(`https://mainnet.infura.io/v3/${process.env.INFURA_PROJECT_ID}`);

const contract = new ethers.Contract(
  process.env.CONTRACT_ADDRESS,
  abi,
  new ethers.Wallet(process.env.PRIVATE_KEY, provider)
);

const getUserBalance = async (address) => {
  const balance = await contract.getBalance(address);
  return ethers.utils.formatEther(balance);
};

const deposit = async (amount) => {
  const tx = await contract.deposit({ value: ethers.utils.parseEther(amount) });
  await tx.wait();
};

module.exports = {
  getUserBalance,
  deposit,
};
