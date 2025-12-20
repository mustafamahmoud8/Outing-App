const express = require('express');
const router = express.Router();
const {
  createConversation,
  sendMessage,
  getConversation,
  getUserConversations,
  togglePinConversation,
  toggleArchiveConversation,
  updateConversationTitle,
  deleteConversation,
  clearConversation
} = require('../controllers/aiConversationController');
const { protect } = require('../middleware/authMiddleware');

// All routes require authentication
router.use(protect);

// AI Conversation routes
router.post('/', createConversation); // Create new conversation
router.get('/', getUserConversations); // Get all user conversations
router.get('/:conversationId', getConversation); // Get conversation by ID
router.post('/:conversationId/message', sendMessage); // Send message to AI
router.put('/:conversationId/pin', togglePinConversation); // Pin/unpin conversation
router.put('/:conversationId/archive', toggleArchiveConversation); // Archive/unarchive conversation
router.put('/:conversationId/title', updateConversationTitle); // Update conversation title
router.delete('/:conversationId', deleteConversation); // Delete conversation
router.post('/:conversationId/clear', clearConversation); // Clear conversation messages

module.exports = router;

