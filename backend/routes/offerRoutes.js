const express = require("express");
const router = express.Router();

const { protect } = require("../middleware/authMiddleware");
const offerController = require("../controllers/offerController");

// Get all offers
router.get("/", offerController.getOffers);

// إنشاء عرض جديد
router.post("/create", protect, offerController.createOffer);

// Update an offer
router.put("/:id", protect, offerController.updateOffer);

// Delete an offer
router.delete("/:id", protect, offerController.deleteOffer);

module.exports = router;
