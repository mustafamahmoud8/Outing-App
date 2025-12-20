const mongoose = require('mongoose');

const conversationSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  
  // Conversation title (auto-generated from first message)
  title: {
    type: String,
    default: null,
    trim: true
  },
  
  // Conversation messages history
  messages: [{
    role: {
      type: String,
      enum: ['user', 'assistant', 'system'],
      required: true
    },
    content: {
      type: String,
      required: true
    },
    timestamp: {
      type: Date,
      default: Date.now
    },
    // Optional: plan ID if this message generated a plan
    planId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Plan',
      default: null
    }
  }],
  
  // Last message timestamp
  lastMessageAt: {
    type: Date,
    default: Date.now
  },
  
  // Conversation metadata
  totalMessages: {
    type: Number,
    default: 0
  },
  
  // Total tokens used in this conversation
  totalTokensUsed: {
    type: Number,
    default: 0
  },
  
  // Is conversation pinned/favorite
  isPinned: {
    type: Boolean,
    default: false
  },
  
  // Is conversation archived
  isArchived: {
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
conversationSchema.index({ user: 1, lastMessageAt: -1 });
conversationSchema.index({ user: 1, isPinned: -1, lastMessageAt: -1 });
conversationSchema.index({ user: 1, isArchived: 1, lastMessageAt: -1 });

module.exports = mongoose.model('AIConversation', conversationSchema);

