const mongoose = require("mongoose");

const menuSchema = new mongoose.Schema({
  owner: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  category: String, // Drinks, Pizza, Desserts
  items: [
    {
      name: String,
      price: Number,
      image: String,
    },
  ],
});

module.exports = mongoose.model("Menu", menuSchema);
