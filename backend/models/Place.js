const mongoose = require('mongoose');

const placeSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  description: String,
  category: {
    type: String,
    enum: ['Restaurant', 'Cafe', 'Park', 'Museum', 'Shopping', 'Hotel', 'Entertainment', 'Cinema', 'Amusement Park', 'Beach', 'Sports'],
    required: true
  },
  price: {
    type: Number,
    required: true,
    min: 0
  },
  minPrice: {
    type: Number,
    default: 0
  },
  maxPrice: {
    type: Number,
    required: true
  },
  location: {
    address: String,
    city: String,
    coordinates: {
      lat: Number,
      lng: Number
    }
  },
  rating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5
  },
  images: [String],
  amenities: [String],
  phone: String,
  ownerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }
}, { timestamps: true });

module.exports = mongoose.model('Place', placeSchema);
