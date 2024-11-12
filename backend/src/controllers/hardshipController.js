// src/controllers/hardshipController.js
const User = require("../models/User");
const crypto = require("crypto");

/**
 * Generates an array of 3 unique hardship codes.
 */
const generateHardshipCodes = () => {
  return Array.from({ length: 3 }, () => crypto.randomBytes(4).toString("hex"));
};

/**
 * Retrieves hardship codes for a specific user based on their address.
 * @param {Object} req - Express request object containing the user's address in params.
 * @param {Object} res - Express response object used to send back the hardship codes.
 * @param {Function} next - Express next middleware function to pass control in case of an error.
 */
const getHardshipCodes = async (req, res, next) => {
  try {
    const { address } = req.params;

    // Find user by address
    const user = await User.findOne({ address });
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
        data: null
      });
    }

    // Return hardship codes if user is found
    res.json({
      success: true,
      message: "Hardship codes retrieved successfully",
      data: user.hardshipCodes
    });
  } catch (err) {
    console.error("Error fetching hardship codes:", err);

    // Pass the error to the global error handler middleware
    next(err);
  }
};

/**
 * Generates and saves new hardship codes for a specific user.
 * @param {Object} req - Express request object containing the user's address in body.
 * @param {Object} res - Express response object used to send back the generated hardship codes.
 * @param {Function} next - Express next middleware function to pass control in case of an error.
 */
const createHardshipCodes = async (req, res, next) => {
  try {
    const { address } = req.body;

    // Find or create a new user entry for the given address
    let user = await User.findOne({ address });
    if (!user) {
      user = new User({ address });
    }

    // Generate and save new hardship codes
    user.hardshipCodes = generateHardshipCodes();
    await user.save();

    res.json({
      success: true,
      message: "Hardship codes generated successfully",
      data: user.hardshipCodes
    });
  } catch (err) {
    console.error("Error creating hardship codes:", err);

    // Pass the error to the global error handler middleware
    next(err);
  }
};

module.exports = {
  getHardshipCodes,
  createHardshipCodes
};
