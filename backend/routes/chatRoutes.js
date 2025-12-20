const express = require('express');
const router = express.Router();
const {
  createChat,
  getUserChats,
  getChatById,
  connectToChat,
  getChatMessages,
  sendMessage,
  deleteMessage,
  getTechnicalSupportChat,
  markAsRead
} = require('../controllers/chatController');
const { protect } = require('../middleware/authMiddleware');

// All routes require authentication
router.use(protect);

// Chat routes
router.post('/', createChat); // Create new chat
router.get('/', getUserChats); // Get all chats for user
router.get('/technical-support', getTechnicalSupportChat); // Get technical support chat
router.get('/:chatId', getChatById); // Get chat by ID
router.post('/:chatId/connect', connectToChat); // Connect to chat

// Message routes
router.get('/:chatId/messages', getChatMessages); // Get messages for a chat
router.post('/:chatId/messages', sendMessage); // Send message to chat
router.delete('/messages/:messageId', deleteMessage); // Delete message
router.post('/:chatId/read', markAsRead); // Mark messages as read

module.exports = router;

