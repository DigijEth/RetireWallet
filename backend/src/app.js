// src/app.js
require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const apiRoutes = require("./routes/api");

const app = express();
app.use(express.json());

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log("MongoDB connected"))
.catch((err) => console.error("MongoDB connection error:", err));

app.use("/api", apiRoutes);

// Global Error Handling Middleware
app.use((err, req, res, next) => {
  console.error("An unexpected error occurred:", err);
  res.status(500).json({
    message: "An unexpected error occurred. Please try again later.",
    error: process.env.NODE_ENV === "development" ? err.message : undefined,
  });
});

module.exports = app;
