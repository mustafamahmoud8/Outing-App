exports.addOrUpdateCategory = async (req, res) => {
  try {
    const { category, items } = req.body;

    let menu = await Menu.findOne({ owner: req.user.id, category });

    if (menu) {
      menu.items = items;
      await menu.save();
    } else {
      menu = await Menu.create({
        owner: req.user.id,
        category,
        items,
      });
    }

    res.json({ message: "Menu category saved", menu });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
