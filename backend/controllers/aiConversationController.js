const AIConversation = require('../models/AIConversation');
const Plan = require('../models/Plan');

// Utils
const { ok, created, badRequest, notFound, serverError } = require('../utils/responseHelper');
const { isValidObjectId, validatePagination } = require('../utils/validators');
const { generateChatResponse, extractPlanData } = require('../utils/aiService');

// =============================
//     Create New Conversation
// =============================
exports.createConversation = async (req, res) => {
  try {
    const userId = req.user.id;

    // Create new conversation
    const conversation = new AIConversation({
      user: userId,
      title: null,
      messages: [],
      totalMessages: 0,
      totalTokensUsed: 0
    });

    await conversation.save();

    return created(res, 'Conversation created successfully', { conversation });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Send Message to AI
// =============================
exports.sendMessage = async (req, res) => {
  try {
    const { conversationId } = req.params;
    const { message, budget, location, categories, groupType } = req.body;
    const userId = req.user.id;

    // Validate message
    if (!message || message.trim().length === 0) {
      return badRequest(res, 'Message is required');
    }

    if (message.length > 2000) {
      return badRequest(res, 'Message is too long (max 2000 characters)');
    }

    // Validate conversationId
    if (!isValidObjectId(conversationId)) {
      return badRequest(res, 'Invalid conversation ID');
    }

    // Find conversation
    let conversation = await AIConversation.findOne({
      _id: conversationId,
      user: userId,
      isActive: true
    });

    if (!conversation) {
      return notFound(res, 'Conversation not found');
    }

    // Add user message to history
    conversation.messages.push({
      role: 'user',
      content: message.trim(),
      timestamp: new Date()
    });

    // Generate title from first message if not set
    if (!conversation.title && conversation.messages.length === 1) {
      const titleText = message.trim().substring(0, 50);
      conversation.title = titleText.length < message.length ? titleText + '...' : titleText;
    }

    conversation.totalMessages = conversation.messages.length;
    conversation.lastMessageAt = new Date();

    await conversation.save();

    // Prepare conversation history for AI
    const conversationHistory = conversation.messages.map(msg => ({
      role: msg.role,
      content: msg.content
    }));

    // Generate AI response
    try {
      const aiResponse = await generateChatResponse(
        conversationHistory,
        budget,
        location,
        categories,
        groupType
      );

      // Add AI response to history
      let planId = null;

      // Check if AI response suggests creating a plan
      if (aiResponse.shouldCreatePlan) {
        // Create plan record
        const plan = new Plan({
          user: userId,
          userRequest: message.trim(),
          generatedPlan: aiResponse.response,
          planData: {
            budget: budget || null,
            location: location || null,
            categories: categories || [],
            groupType: groupType || null
          },
          status: 'completed',
          aiModel: aiResponse.model || 'gpt-3.5-turbo',
          tokensUsed: aiResponse.tokensUsed || 0
        });

        await plan.save();
        planId = plan._id;
      }

      conversation.messages.push({
        role: 'assistant',
        content: aiResponse.response,
        planId: planId,
        timestamp: new Date()
      });

      conversation.totalMessages = conversation.messages.length;
      conversation.totalTokensUsed += aiResponse.tokensUsed || 0;
      conversation.lastMessageAt = new Date();

      await conversation.save();

      return ok(res, 'Message sent successfully', {
        conversation: {
          id: conversation._id,
          title: conversation.title,
          messages: conversation.messages,
          totalMessages: conversation.totalMessages,
          lastMessageAt: conversation.lastMessageAt
        },
        aiResponse: {
          message: aiResponse.response,
          planId: planId,
          tokensUsed: aiResponse.tokensUsed || 0
        }
      });

    } catch (error) {
      console.error('AI Response Error:', error);

      // Add error message to conversation
      conversation.messages.push({
        role: 'assistant',
        content: 'عذراً، حدث خطأ أثناء معالجة طلبك. يرجى المحاولة مرة أخرى.',
        timestamp: new Date()
      });

      conversation.totalMessages = conversation.messages.length;
      await conversation.save();

      return serverError(res, 'Failed to get AI response', error);
    }

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Get Conversation by ID
// =============================
exports.getConversation = async (req, res) => {
  try {
    const { conversationId } = req.params;
    const userId = req.user.id;

    if (!isValidObjectId(conversationId)) {
      return badRequest(res, 'Invalid conversation ID');
    }

    const conversation = await AIConversation.findOne({
      _id: conversationId,
      user: userId,
      isActive: true
    });

    if (!conversation) {
      return notFound(res, 'Conversation not found');
    }

    return ok(res, 'Conversation retrieved successfully', { conversation });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Get User Conversations
// =============================
exports.getUserConversations = async (req, res) => {
  try {
    const userId = req.user.id;
    const { page, limit } = validatePagination(req.query.page, req.query.limit, 50);
    const { isPinned, isArchived } = req.query;

    // Build query
    const query = {
      user: userId,
      isActive: true
    };

    if (isPinned !== undefined) {
      query.isPinned = isPinned === 'true';
    }

    if (isArchived !== undefined) {
      query.isArchived = isArchived === 'true';
    }

    // Get conversations
    const conversations = await AIConversation.find(query)
      .sort({ isPinned: -1, lastMessageAt: -1 })
      .limit(limit)
      .skip((page - 1) * limit)
      .select('title messages totalMessages lastMessageAt isPinned isArchived createdAt updatedAt');

    const totalConversations = await AIConversation.countDocuments(query);

    return ok(res, 'Conversations retrieved successfully', {
      conversations,
      pagination: {
        page,
        limit,
        totalConversations,
        totalPages: Math.ceil(totalConversations / limit)
      }
    });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Pin/Unpin Conversation
// =============================
exports.togglePinConversation = async (req, res) => {
  try {
    const { conversationId } = req.params;
    const userId = req.user.id;

    if (!isValidObjectId(conversationId)) {
      return badRequest(res, 'Invalid conversation ID');
    }

    const conversation = await AIConversation.findOne({
      _id: conversationId,
      user: userId,
      isActive: true
    });

    if (!conversation) {
      return notFound(res, 'Conversation not found');
    }

    conversation.isPinned = !conversation.isPinned;
    await conversation.save();

    return ok(res, `Conversation ${conversation.isPinned ? 'pinned' : 'unpinned'} successfully`, { conversation });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Archive/Unarchive Conversation
// =============================
exports.toggleArchiveConversation = async (req, res) => {
  try {
    const { conversationId } = req.params;
    const userId = req.user.id;

    if (!isValidObjectId(conversationId)) {
      return badRequest(res, 'Invalid conversation ID');
    }

    const conversation = await AIConversation.findOne({
      _id: conversationId,
      user: userId,
      isActive: true
    });

    if (!conversation) {
      return notFound(res, 'Conversation not found');
    }

    conversation.isArchived = !conversation.isArchived;
    await conversation.save();

    return ok(res, `Conversation ${conversation.isArchived ? 'archived' : 'unarchived'} successfully`, { conversation });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Update Conversation Title
// =============================
exports.updateConversationTitle = async (req, res) => {
  try {
    const { conversationId } = req.params;
    const { title } = req.body;
    const userId = req.user.id;

    if (!isValidObjectId(conversationId)) {
      return badRequest(res, 'Invalid conversation ID');
    }

    if (!title || title.trim().length === 0) {
      return badRequest(res, 'Title is required');
    }

    const conversation = await AIConversation.findOne({
      _id: conversationId,
      user: userId,
      isActive: true
    });

    if (!conversation) {
      return notFound(res, 'Conversation not found');
    }

    conversation.title = title.trim();
    await conversation.save();

    return ok(res, 'Conversation title updated successfully', { conversation });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Delete Conversation
// =============================
exports.deleteConversation = async (req, res) => {
  try {
    const { conversationId } = req.params;
    const userId = req.user.id;

    if (!isValidObjectId(conversationId)) {
      return badRequest(res, 'Invalid conversation ID');
    }

    const conversation = await AIConversation.findOne({
      _id: conversationId,
      user: userId
    });

    if (!conversation) {
      return notFound(res, 'Conversation not found');
    }

    conversation.isActive = false;
    await conversation.save();

    return ok(res, 'Conversation deleted successfully');

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Clear Conversation Messages
// =============================
exports.clearConversation = async (req, res) => {
  try {
    const { conversationId } = req.params;
    const userId = req.user.id;

    if (!isValidObjectId(conversationId)) {
      return badRequest(res, 'Invalid conversation ID');
    }

    const conversation = await AIConversation.findOne({
      _id: conversationId,
      user: userId,
      isActive: true
    });

    if (!conversation) {
      return notFound(res, 'Conversation not found');
    }

    conversation.messages = [];
    conversation.totalMessages = 0;
    conversation.totalTokensUsed = 0;
    await conversation.save();

    return ok(res, 'Conversation cleared successfully', { conversation });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

