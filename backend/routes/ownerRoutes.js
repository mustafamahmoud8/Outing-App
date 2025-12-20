const express = require("express");
const router = express.Router();

const { protect } = require("../middleware/authMiddleware");
const ownerOnly = require("../middleware/ownerOnly");

const {
  getOwnerDashboard,
  updatePlaceInfo,
  addMenuCategory,
  addMenuItem,
} = require("../controllers/ownerController");

// Test route (optional)
router.get("/anything", ownerOnly, (req, res) => {
  res.json({ message: "Owner route working" });
});

// Dashboard API
router.get("/dashboard", protect, ownerOnly, getOwnerDashboard);

// Update place info
router.put("/place", protect, ownerOnly, updatePlaceInfo);

// Menu categories
router.post("/menu/category", protect, ownerOnly, addMenuCategory);

// Menu items
router.post("/menu/item", protect, ownerOnly, addMenuItem);

module.exports = router;
