// src/controllers/hardshipController.js
const User = require("../models/User");
const crypto = require("crypto");

const generateHardshipCodes = () => {
  return Array.from({ length: 3 }, () => crypto.randomBytes(4).toString("hex"));
};

const getHardshipCodes = async (req, res, next) => {
  try {
    const { address } = req.params;
    const user = await User.findOne({ address });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json({ hardshipCodes: user.hardshipCodes });
  } catch (err) {
    console.error("Error fetching hardship codes:", err);
    next(err); // Pass the error to the global error handler
  }
};

const createHardshipCodes = async (req, res, next) => {
  try {
    const { address } = req.body;
    let user = await User.findOne({ address });
    if (!user) {
      user = new User({ address });
    }

    user.hardshipCodes = generateHardshipCodes();
    await user.save();

    res.json({ hardshipCodes: user.hardshipCodes });
  } catch (err) {
    console.error("Error creating hardship codes:", err);
    next(err); // Pass the error to the global error handler
  }
};

module.exports = {
  getHardshipCodes,
  createHardshipCodes,
};
