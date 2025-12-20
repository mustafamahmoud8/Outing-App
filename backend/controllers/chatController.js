const Chat = require('../models/Chat');
const Message = require('../models/Message');
const User = require('../models/User');

// Utils
const { ok, created, badRequest, notFound, serverError } = require('../utils/responseHelper');
const { isValidChatType, isValidMessageType, isValidObjectId, validatePagination } = require('../utils/validators');
const { CHAT_TYPES, MESSAGE_TYPES, MESSAGE_STATUS } = require('../utils/constants');
const { formatChat, formatMessage, validateParticipants } = require('../utils/chatHelper');
const { calculatePagination, formatPaginatedResponse } = require('../utils/paginationHelper');

// =============================
//     Create New Chat
// =============================
exports.createChat = async (req, res) => {
  try {
    const { type, participantIds, title } = req.body;
    const userId = req.user.id;

    // Validate chat type
    if (!isValidChatType(type)) {
      return badRequest(res, 'Invalid chat type');
    }

    // Validate participants
    const participantsValidation = validateParticipants(type, participantIds);
    if (!participantsValidation.isValid) {
      return badRequest(res, participantsValidation.message);
    }

    // Ensure current user is included in participants
    const allParticipants = [...new Set([userId, ...(participantIds || [])])];

    // Check if private chat already exists between these two users
    if (type === CHAT_TYPES.PRIVATE && allParticipants.length === 2) {
      const existingChat = await Chat.findOne({
        type: CHAT_TYPES.PRIVATE,
        participants: { $all: allParticipants, $size: 2 },
        isActive: true
      });

      if (existingChat) {
        return ok(res, 'Chat already exists', { chat: existingChat });
      }
    }

    // Create new chat
    const chat = new Chat({
      type,
      participants: allParticipants,
      title: title || null,
      isConnected: false,
      unreadCount: allParticipants.map(id => ({ user: id, count: 0 }))
    });

    await chat.save();
    await chat.populate('participants', 'name avatar email phone');

    return created(res, 'Chat created successfully', { chat });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Get All Chats for User
// =============================
exports.getUserChats = async (req, res) => {
  try {
    const userId = req.user.id;

    const chats = await Chat.find({
      participants: userId,
      isActive: true
    })
      .populate('participants', 'name avatar email phone')
      .populate('lastMessage')
      .sort({ lastMessageAt: -1, createdAt: -1 });

    return ok(res, 'Chats retrieved successfully', { chats });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Get Chat by ID
// =============================
exports.getChatById = async (req, res) => {
  try {
    const { chatId } = req.params;
    const userId = req.user.id;

    const chat = await Chat.findOne({
      _id: chatId,
      participants: userId,
      isActive: true
    })
      .populate('participants', 'name avatar email phone')
      .populate('lastMessage');

    if (!chat) {
      return notFound(res, 'Chat not found');
    }

    return ok(res, 'Chat retrieved successfully', { chat });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Connect to Chat
// =============================
exports.connectToChat = async (req, res) => {
  try {
    const { chatId } = req.params;
    const userId = req.user.id;

    const chat = await Chat.findOne({
      _id: chatId,
      participants: userId
    });

    if (!chat) {
      return notFound(res, 'Chat not found');
    }

    chat.isConnected = true;
    await chat.save();

    return ok(res, 'Connected to chat successfully', { chat });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Get Messages for Chat
// =============================
exports.getChatMessages = async (req, res) => {
  try {
    const { chatId } = req.params;
    const userId = req.user.id;

    // Validate chatId
    if (!isValidObjectId(chatId)) {
      return badRequest(res, 'Invalid chat ID');
    }

    // Validate and calculate pagination
    const { page, limit, skip } = validatePagination(req.query.page, req.query.limit, 100);

    // Verify user is participant
    const chat = await Chat.findOne({
      _id: chatId,
      participants: userId
    });

    if (!chat) {
      return notFound(res, 'Chat not found');
    }

    // Get messages
    const messages = await Message.find({
      chat: chatId,
      isDeleted: false
    })
      .populate('sender', 'name avatar email phone')
      .populate('replyTo')
      .sort({ createdAt: -1 })
      .limit(limit)
      .skip(skip);

    const totalMessages = await Message.countDocuments({
      chat: chatId,
      isDeleted: false
    });

    // Mark messages as read for current user
    await Message.updateMany(
      {
        chat: chatId,
        sender: { $ne: userId },
        'readBy.user': { $ne: userId }
      },
      {
        $push: {
          readBy: {
            user: userId,
            readAt: new Date()
          }
        },
        status: MESSAGE_STATUS.READ
      }
    );

    // Update unread count for this user
    await Chat.updateOne(
      { _id: chatId, 'unreadCount.user': userId },
      { $set: { 'unreadCount.$.count': 0 } }
    );

    // Calculate pagination
    const pagination = calculatePagination(page, limit, totalMessages);

    // Format messages
    const formattedMessages = messages.reverse().map(msg => formatMessage(msg, userId));

    return res.json(formatPaginatedResponse(formattedMessages, pagination, 'Messages retrieved successfully'));

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Send Message
// =============================
exports.sendMessage = async (req, res) => {
  try {
    const { chatId } = req.params;
    const { content, messageType, mediaUrl, replyTo } = req.body;
    const userId = req.user.id;

    // Validate input
    if (!content && !mediaUrl) {
      return badRequest(res, 'Message content or media is required');
    }

    // Validate chatId
    if (!isValidObjectId(chatId)) {
      return badRequest(res, 'Invalid chat ID');
    }

    // Validate message type if provided
    if (messageType && !isValidMessageType(messageType)) {
      return badRequest(res, 'Invalid message type');
    }

    // Verify user is participant
    const chat = await Chat.findOne({
      _id: chatId,
      participants: userId,
      isActive: true
    });

    if (!chat) {
      return notFound(res, 'Chat not found');
    }

    // Create message
    const message = new Message({
      chat: chatId,
      sender: userId,
      content: content || '',
      messageType: messageType || MESSAGE_TYPES.TEXT,
      mediaUrl: mediaUrl || null,
      replyTo: replyTo || null,
      status: MESSAGE_STATUS.SENT
    });

    await message.save();

    // Update chat's last message
    chat.lastMessage = message._id;
    chat.lastMessageAt = new Date();
    chat.isConnected = true;

    // Update unread counts for other participants
    const otherParticipantIds = chat.participants
      .filter(p => p.toString() !== userId.toString())
      .map(p => p.toString());

    chat.unreadCount = chat.unreadCount.map(item => {
      if (otherParticipantIds.includes(item.user.toString())) {
        return { ...item, count: item.count + 1 };
      }
      return item;
    });

    await chat.save();

    // Populate message with sender info
    await message.populate('sender', 'name avatar email phone');
    if (replyTo) {
      await message.populate('replyTo');
    }

    const formattedMessage = formatMessage(message, userId);

    return created(res, 'Message sent successfully', { message: formattedMessage });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Delete Message
// =============================
exports.deleteMessage = async (req, res) => {
  try {
    const { messageId } = req.params;
    const userId = req.user.id;

    // Validate messageId
    if (!isValidObjectId(messageId)) {
      return badRequest(res, 'Invalid message ID');
    }

    const message = await Message.findOne({
      _id: messageId,
      sender: userId
    });

    if (!message) {
      return notFound(res, 'Message not found');
    }

    message.isDeleted = true;
    await message.save();

    return ok(res, 'Message deleted successfully');

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Get Technical Support Chat
// =============================
exports.getTechnicalSupportChat = async (req, res) => {
  try {
    const userId = req.user.id;

    // Find or create technical support chat
    let chat = await Chat.findOne({
      type: CHAT_TYPES.TECHNICAL_SUPPORT,
      participants: userId,
      isActive: true
    })
      .populate('participants', 'name avatar email phone')
      .populate('lastMessage');

    if (!chat) {
      // Create new technical support chat
      chat = new Chat({
        type: CHAT_TYPES.TECHNICAL_SUPPORT,
        participants: [userId],
        isConnected: false,
        unreadCount: [{ user: userId, count: 0 }]
      });
      await chat.save();
      await chat.populate('participants', 'name avatar email phone');
    }

    return ok(res, 'Technical support chat retrieved', { chat });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Mark Messages as Read
// =============================
exports.markAsRead = async (req, res) => {
  try {
    const { chatId } = req.params;
    const userId = req.user.id;

    // Validate chatId
    if (!isValidObjectId(chatId)) {
      return badRequest(res, 'Invalid chat ID');
    }

    // Mark all unread messages in chat as read
    await Message.updateMany(
      {
        chat: chatId,
        sender: { $ne: userId },
        'readBy.user': { $ne: userId },
        isDeleted: false
      },
      {
        $push: {
          readBy: {
            user: userId,
            readAt: new Date()
          }
        },
        $set: { status: MESSAGE_STATUS.READ }
      }
    );

    // Reset unread count
    await Chat.updateOne(
      { _id: chatId, 'unreadCount.user': userId },
      { $set: { 'unreadCount.$.count': 0 } }
    );

    return ok(res, 'Messages marked as read');

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

