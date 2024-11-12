// src/routes/api.js
const express = require("express");
const { getHardshipCodes, createHardshipCodes } = require("../controllers/hardshipController");
const router = express.Router();

router.get("/hardship/:address", getHardshipCodes);
router.post("/hardship", createHardshipCodes);

module.exports = router;
