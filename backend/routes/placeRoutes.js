const express = require("express");
const router = express.Router();
const { protect } = require("../middleware/authMiddleware");
const { ownerOnly } = require("../middleware/ownerOnly");
const { createOrUpdatePlace, getPlaces, updatePlace, deletePlace } = require("../controllers/placeController");

router.post("/", protect, ownerOnly, createOrUpdatePlace);
router.get("/", getPlaces);
router.put("/:id", protect, ownerOnly, updatePlace);
router.delete("/:id", protect, ownerOnly, deletePlace);

module.exports = router;
