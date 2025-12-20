const express = require("express");
const router = express.Router();
const { protect } = require("../middleware/authMiddleware");
const { ownerOnly } = require("../middleware/ownerOnly");
const { addOrUpdateCategory } = require("../controllers/menuController");

router.post("/category", protect, ownerOnly, addOrUpdateCategory);

module.exports = router;
