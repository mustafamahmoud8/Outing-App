const mongoose = require("mongoose");

const offerSchema = new mongoose.Schema({
  owner: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  title: String,
  description: String,
  discount: Number,
  expiresAt: Date,
});

module.exports = mongoose.model("Offer", offerSchema);
