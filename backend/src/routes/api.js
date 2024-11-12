// src/routes/api.js
const express = require("express");
const { getHardshipCodes, createHardshipCodes } = require("../controllers/hardshipController");
const router = express.Router();

router.get("/hardship/:address", async (req, res, next) => {
  try {
    await getHardshipCodes(req, res);
  } catch (err) {
    next(err);
  }
});

router.post("/hardship", async (req, res, next) => {
  try {
    await createHardshipCodes(req, res);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
