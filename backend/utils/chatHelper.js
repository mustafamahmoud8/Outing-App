/**
 * Chat Helper Utilities
 * Helper functions specific to chat functionality
 */

// =============================
//     Format Chat for Response
// =============================
const formatChat = (chat, userId) => {
  if (!chat) return null;
  
  const chatObj = chat.toObject ? chat.toObject() : chat;
  
  // Get other participants (excluding current user)
  const otherParticipants = chatObj.participants?.filter(
    p => p._id?.toString() !== userId?.toString() && p.toString() !== userId?.toString()
  ) || [];
  
  // Get unread count for current user
  const unreadCountItem = chatObj.unreadCount?.find(
    item => item.user?.toString() === userId?.toString() || item.user === userId
  );
  const unreadCount = unreadCountItem?.count || 0;
  
  return {
    ...chatObj,
    otherParticipants,
    unreadCount,
    participantCount: chatObj.participants?.length || 0
  };
};

// =============================
//     Format Message for Response
// =============================
const formatMessage = (message, userId) => {
  if (!message) return null;
  
  const messageObj = message.toObject ? message.toObject() : message;
  
  // Check if message is read by current user
  const isRead = messageObj.readBy?.some(
    read => read.user?.toString() === userId?.toString() || read.user === userId
  ) || false;
  
  // Check if message is sent by current user
  const isSentByMe = messageObj.sender?.toString() === userId?.toString() || 
                     messageObj.sender?._id?.toString() === userId?.toString();
  
  return {
    ...messageObj,
    isRead,
    isSentByMe
  };
};

// =============================
//     Get Chat Title (Auto-generate)
// =============================
const getChatTitle = (chat, userId) => {
  if (chat.title) return chat.title;
  
  // For private chats, use other participant's name
  if (chat.type === 'private' && chat.participants) {
    const otherParticipant = chat.participants.find(
      p => p._id?.toString() !== userId?.toString() && p.toString() !== userId?.toString()
    );
    return otherParticipant?.name || 'دردشة خاصة';
  }
  
  // For technical support
  if (chat.type === 'technical_support') {
    return 'الدعم الفني';
  }
  
  // For new chats, use default or participant count
  if (chat.participants?.length) {
    return `دردشة (${chat.participants.length})`;
  }
  
  return 'دردشة جديدة';
};

// =============================
//     Validate Participants Count
// =============================
const validateParticipants = (type, participantIds) => {
  if (type === 'private' && (!participantIds || participantIds.length !== 2)) {
    return {
      isValid: false,
      message: 'Private chat must have exactly 2 participants'
    };
  }
  
  if (type === 'new' && participantIds && participantIds.length < 1) {
    return {
      isValid: false,
      message: 'New chat must have at least 1 participant'
    };
  }
  
  return { isValid: true };
};

// =============================
//     Sort Messages by Date
// =============================
const sortMessagesByDate = (messages, ascending = true) => {
  if (!messages || !Array.isArray(messages)) return [];
  
  return [...messages].sort((a, b) => {
    const dateA = new Date(a.createdAt || a.created_at || 0);
    const dateB = new Date(b.createdAt || b.created_at || 0);
    
    return ascending ? dateA - dateB : dateB - dateA;
  });
};

// =============================
//     Group Messages by Date
// =============================
const groupMessagesByDate = (messages) => {
  if (!messages || !Array.isArray(messages)) return {};
  
  const grouped = {};
  
  messages.forEach(message => {
    const date = new Date(message.createdAt || message.created_at);
    const dateKey = date.toISOString().split('T')[0]; // YYYY-MM-DD
    
    if (!grouped[dateKey]) {
      grouped[dateKey] = [];
    }
    
    grouped[dateKey].push(message);
  });
  
  return grouped;
};

module.exports = {
  formatChat,
  formatMessage,
  getChatTitle,
  validateParticipants,
  sortMessagesByDate,
  groupMessagesByDate
};

