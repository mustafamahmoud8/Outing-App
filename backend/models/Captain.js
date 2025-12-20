const mongoose = require('mongoose');

const captainSchema = new mongoose.Schema({
  // Captain's user account
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true,
    index: true
  },

  // Captain details
  name: {
    type: String,
    required: true,
    trim: true
  },

  phone: {
    type: String,
    required: true,
    unique: true,
    index: true
  },

  email: {
    type: String,
    trim: true,
    lowercase: true
  },

  // Profile photo
  photo: {
    type: String,
    default: null
  },

  // Vehicle information
  vehicle: {
    type: {
      type: String,
      enum: ['car', 'van', 'bus', 'motorcycle'],
      required: true
    },
    make: String,      // Toyota, Honda, etc.
    model: String,     // Camry, Civic, etc.
    year: Number,
    color: String,
    plateNumber: {
      type: String,
      required: true,
      unique: true
    },
    capacity: {
      type: Number,
      default: 4
    },
    photos: [String]
  },

  // License information
  license: {
    number: {
      type: String,
      required: true,
      unique: true
    },
    expiryDate: Date,
    isVerified: {
      type: Boolean,
      default: false
    }
  },

  // Current location (for matching with nearby requests)
  currentLocation: {
    latitude: Number,
    longitude: Number,
    lastUpdated: Date
  },

  // Availability
  isAvailable: {
    type: Boolean,
    default: true
  },

  isOnline: {
    type: Boolean,
    default: false
  },

  // Rating and reviews
  rating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5
  },

  ratingCount: {
    type: Number,
    default: 0
  },

  totalRides: {
    type: Number,
    default: 0
  },

  // Earnings
  totalEarnings: {
    type: Number,
    default: 0
  },

  // Verification status
  isVerified: {
    type: Boolean,
    default: false
  },

  verificationDocuments: [{
    type: String,
    url: String,
    uploadedAt: Date,
    status: {
      type: String,
      enum: ['pending', 'approved', 'rejected'],
      default: 'pending'
    }
  }],

  // Account status
  isActive: {
    type: Boolean,
    default: true
  },

  isSuspended: {
    type: Boolean,
    default: false
  },

  suspensionReason: {
    type: String,
    default: null
  },

  // Working areas/cities
  serviceAreas: [{
    type: String
  }],

  // Bank details for payments
  bankDetails: {
    accountName: String,
    accountNumber: String,
    bankName: String,
    routingNumber: String
  }

}, {
  timestamps: true,
  toJSON: {
    transform: (doc, ret) => {
      delete ret.__v;
      delete ret.bankDetails; // Don't expose bank details in API responses
      return ret;
    }
  }
});

// Indexes for faster queries
captainSchema.index({ phone: 1 });
captainSchema.index({ isAvailable: 1, isOnline: 1, isActive: 1 });
captainSchema.index({ rating: -1, totalRides: -1 });
captainSchema.index({ 'currentLocation.latitude': 1, 'currentLocation.longitude': 1 });

module.exports = mongoose.model('Captain', captainSchema);
