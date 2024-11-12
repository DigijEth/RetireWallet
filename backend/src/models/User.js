// src/models/User.js
const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({
  address: { type: String, required: true, unique: true },
  hardshipCodes: { type: [String], default: [] }, // Array of hardship codes
  balance: { type: String, default: "0" },
});

module.exports = mongoose.model("User", UserSchema);
