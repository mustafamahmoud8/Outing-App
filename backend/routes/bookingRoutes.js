const express = require("express");
const router = express.Router();
const bookingController = require("../controllers/bookingController");

router.post("/create", bookingController.createBooking);
router.put("/:id/status", bookingController.updateBookingStatus);

module.exports = router;
