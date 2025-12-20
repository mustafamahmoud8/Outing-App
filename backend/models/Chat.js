const mongoose = require('mongoose');

const chatSchema = new mongoose.Schema({
  type: {
    type: String,
    enum: ['new', 'technical_support', 'private'], // دردشة جديدة، الدعم الفني، دردشة خاصة
    required: true
  },
  
  participants: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  }],
  
  // For private chats, we need exactly 2 participants
  // For technical support, typically user + admin/support staff
  // For new chats, can be multiple
  
  lastMessage: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Message'
  },
  
  lastMessageAt: {
    type: Date,
    default: Date.now
  },
  
  // Connection status for chat
  isConnected: {
    type: Boolean,
    default: false
  },
  
  // Unread message count per participant
  unreadCount: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    count: {
      type: Number,
      default: 0
    }
  }],
  
  // Chat metadata
  title: {
    type: String, // Optional title for group chats
    default: null
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

// Index for faster queries
chatSchema.index({ participants: 1, createdAt: -1 });
chatSchema.index({ type: 1, createdAt: -1 });

module.exports = mongoose.model('Chat', chatSchema);

