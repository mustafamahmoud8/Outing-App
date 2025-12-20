const mongoose = require('mongoose');

const planSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  
  // User's request/prompt
  userRequest: {
    type: String,
    required: true,
    trim: true
  },
  
  // AI generated plan
  generatedPlan: {
    type: String,
    required: true
  },
  
  // Structured plan data (optional)
  planData: {
    budget: {
      type: Number,
      default: null
    },
    location: {
      type: String,
      default: null
    },
    categories: [{
      type: String
    }],
    groupType: {
      type: String,
      enum: ['individual', 'couple', 'friends', 'family'],
      default: null
    },
    places: [{
      name: String,
      type: String,
      address: String,
      estimatedCost: Number,
      description: String
    }],
    totalEstimatedCost: {
      type: Number,
      default: null
    },
    duration: {
      type: String,
      default: null
    }
  },
  
  // Status: generating, completed, failed
  status: {
    type: String,
    enum: ['generating', 'completed', 'failed'],
    default: 'generating'
  },
  
  // AI model used
  aiModel: {
    type: String,
    default: 'gpt-3.5-turbo'
  },
  
  // Error message if failed
  error: {
    type: String,
    default: null
  },
  
  // Usage statistics
  tokensUsed: {
    type: Number,
    default: 0
  },
  
  // Is plan saved/favorited
  isSaved: {
    type: Boolean,
    default: false
  },
  
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
planSchema.index({ user: 1, createdAt: -1 });
planSchema.index({ status: 1, createdAt: -1 });
planSchema.index({ isSaved: 1, createdAt: -1 });

module.exports = mongoose.model('Plan', planSchema);

