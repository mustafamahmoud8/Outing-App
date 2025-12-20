const mongoose = require("mongoose");

const bookingSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  owner: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  date: String,
  time: String,
  people: Number,
  status: { type: String, default: "pending" }, // accepted / rejected
});

module.exports = mongoose.model("Booking", bookingSchema);
