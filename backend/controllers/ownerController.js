const User = require("../models/User");

// Owner dashboard stats
exports.getOwnerDashboard = async (req, res) => {
  res.json({
    message: "Owner dashboard loaded",
    owner: req.user,
  });
};

// Update place info
exports.updatePlaceInfo = async (req, res) => {
  const { placeName, placeType, placeAddress, placePhone } = req.body;

  const user = await User.findById(req.user._id);

  if (placeName) user.placeName = placeName;
  if (placeType) user.placeType = placeType;
  if (placeAddress) user.placeAddress = placeAddress;
  if (placePhone) user.placePhone = placePhone;

  await user.save();

  res.json({
    message: "Place updated",
    user,
  });
};

// Add menu category
exports.addMenuCategory = async (req, res) => {
  try {
    const { category } = req.body;
    const menu = await Menu.findOne({ owner: req.user.id, category });

    if (menu) {
      return res.status(400).json({ message: "Category already exists" });
    }

    const newMenu = await Menu.create({
      owner: req.user.id,
      category,
      items: [],
    });

    res.json({ message: "Category added", menu: newMenu });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Add menu item
exports.addMenuItem = async (req, res) => {
  try {
    const { category, item } = req.body;
    const menu = await Menu.findOne({ owner: req.user.id, category });

    if (!menu) {
      return res.status(404).json({ message: "Category not found" });
    }

    menu.items.push(item);
    await menu.save();

    res.json({ message: "Item added", menu });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
