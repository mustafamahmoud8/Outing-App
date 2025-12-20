const mongoose = require('mongoose');

const engagementSchema = new mongoose.Schema({
  // User who created the engagement
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },

  // Related plan (optional)
  plan: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Plan',
    default: null
  },

  // Engagement title
  title: {
    type: String,
    required: true,
    trim: true
  },

  // Date of the engagement
  date: {
    type: Date,
    required: true,
    index: true
  },

  // Time Table - Schedule of places to visit
  timeTable: [{
    place: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Place',
      required: true
    },
    placeName: String,
    startTime: String, // "09:00"
    endTime: String,   // "11:00"
    duration: Number,  // in minutes
    notes: String,
    order: Number,     // sequence order
    estimatedCost: Number,

    // Booking reference for this place
    booking: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Booking',
      default: null
    },

    // Status for this specific place visit
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'completed', 'cancelled', 'skipped'],
      default: 'pending'
    }
  }],

  // Captain/Driver Service
  captainService: {
    isRequested: {
      type: Boolean,
      default: false
    },
    captain: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      default: null
    },
    pickupLocation: {
      address: String,
      latitude: Number,
      longitude: Number
    },
    pickupTime: String,
    captainStatus: {
      type: String,
      enum: ['pending', 'accepted', 'rejected', 'arrived', 'in-progress', 'completed'],
      default: 'pending'
    },
    estimatedFare: Number,
    actualFare: Number,
    captainNotes: String
  },

  // Live Location Sharing
  liveLocationSharing: {
    isEnabled: {
      type: Boolean,
      default: false
    },
    sharedWith: [{
      user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
      },
      name: String,
      phone: String,
      canEdit: {
        type: Boolean,
        default: false
      }
    }],
    currentLocation: {
      latitude: Number,
      longitude: Number,
      lastUpdated: Date
    }
  },

  // Proximity Notifications Settings
  proximityNotifications: {
    isEnabled: {
      type: Boolean,
      default: true
    },
    notificationRadius: {
      type: Number,
      default: 500 // meters
    },
    notificationsSent: [{
      place: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Place'
      },
      sentAt: Date,
      notified: Boolean
    }]
  },

  // Participants/Friends joining this engagement
  participants: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    name: String,
    phone: String,
    status: {
      type: String,
      enum: ['invited', 'accepted', 'declined', 'maybe'],
      default: 'invited'
    },
    joinedAt: Date
  }],

  // Total budget
  totalBudget: {
    type: Number,
    default: null
  },

  // Actual spent amount
  actualSpent: {
    type: Number,
    default: 0
  },

  // Overall engagement status
  status: {
    type: String,
    enum: ['planned', 'in-progress', 'completed', 'cancelled'],
    default: 'planned'
  },

  // Notes/Description
  notes: {
    type: String,
    default: null
  },

  // Is this engagement saved in user's plans
  isSaved: {
    type: Boolean,
    default: true
  },

  // Is active
  isActive: {
    type: Boolean,
    default: true
  }

}, {
  timestamps: true,
  toJSON: {
    transform: (doc, ret) => {
      delete ret.__v;
      return ret;
    }
  }
});

// Indexes for faster queries
engagementSchema.index({ user: 1, date: -1 });
engagementSchema.index({ status: 1, date: -1 });
engagementSchema.index({ 'captainService.captain': 1, 'captainService.captainStatus': 1 });

module.exports = mongoose.model('Engagement', engagementSchema);
