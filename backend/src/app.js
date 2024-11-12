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

module.exports = app;
