const Place = require("../models/Place");

exports.createOrUpdatePlace = async (req, res) => {
  try {
    const data = { ...req.body, owner: req.user.id };

    let place = await Place.findOne({ owner: req.user.id });

    if (place) {
      place = await Place.findOneAndUpdate({ owner: req.user.id }, data, { new: true });
    } else {
      place = await Place.create(data);
    }

    res.json({ message: "Place saved", place });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.getPlaces = async (req, res) => {
  try {
    const places = await Place.find();
    res.json(places);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.updatePlace = async (req, res) => {
  try {
    const place = await Place.findById(req.params.id);

    if (!place) {
      return res.status(404).json({ message: "Place not found" });
    }

    // Add authorization check if needed

    place.name = req.body.name || place.name;
    place.address = req.body.address || place.address;

    const updatedPlace = await place.save();
    res.json(updatedPlace);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.deletePlace = async (req, res) => {
  try {
    const place = await Place.findById(req.params.id);

    if (!place) {
      return res.status(404).json({ message: "Place not found" });
    }

    // Add authorization check if needed

    await place.deleteOne();
    res.json({ message: "Place removed" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
