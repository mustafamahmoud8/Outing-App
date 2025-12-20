const Offer = require("../models/offer");

exports.createOffer = async (req, res) => {
  try {
    const offer = await Offer.create({
      ...req.body,
      owner: req.user.id,
    });

    res.json({ message: "Offer created", offer });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.getOffers = async (req, res) => {
  try {
    const offers = await Offer.find();
    res.json(offers);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.updateOffer = async (req, res) => {
  try {
    const offer = await Offer.findById(req.params.id);

    if (!offer) {
      return res.status(404).json({ message: "Offer not found" });
    }

    // Add authorization check if needed

    offer.title = req.body.title || offer.title;
    offer.description = req.body.description || offer.description;

    const updatedOffer = await offer.save();
    res.json(updatedOffer);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.deleteOffer = async (req, res) => {
  try {
    const offer = await Offer.findById(req.params.id);

    if (!offer) {
      return res.status(404).json({ message: "Offer not found" });
    }

    // Add authorization check if needed

    await offer.remove();
    res.json({ message: "Offer removed" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
