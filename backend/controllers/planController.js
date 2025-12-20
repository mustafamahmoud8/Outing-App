const Plan = require('../models/Plan');

// Utils
const { ok, created, badRequest, notFound, serverError } = require('../utils/responseHelper');
const { isValidObjectId, validatePagination } = require('../utils/validators');
const { generatePlanWithAI, extractPlanData } = require('../utils/aiService');

// =============================
//     Create Plan (AI Generated)
// =============================
exports.createPlan = async (req, res) => {
  try {
    const { userRequest, budget, location, categories, groupType } = req.body;
    const userId = req.user.id;

    // Validate user request
    if (!userRequest || userRequest.trim().length === 0) {
      return badRequest(res, 'User request is required');
    }

    if (userRequest.length > 1000) {
      return badRequest(res, 'User request is too long (max 1000 characters)');
    }

    // Create plan record with generating status
    const plan = new Plan({
      user: userId,
      userRequest: userRequest.trim(),
      generatedPlan: '',
      planData: {
        budget: budget || null,
        location: location || null,
        categories: categories || [],
        groupType: groupType || null
      },
      status: 'generating'
    });

    await plan.save();

    // Option 1: Async (non-blocking) - return immediately, update in background
    // For real-time response, we can wait for AI response (Option 2 below)
    const waitForResponse = req.query.wait === 'true'; // ?wait=true for synchronous response

    if (!waitForResponse) {
      // Async mode - generate in background
      generatePlanWithAI(userRequest, budget, location, categories, groupType)
        .then(async (aiResponse) => {
          // Extract structured data
          const planData = extractPlanData(
            aiResponse.plan,
            userRequest,
            budget,
            location,
            categories,
            groupType
          );

          // Update plan with AI response
          plan.generatedPlan = aiResponse.plan;
          plan.planData = { ...plan.planData, ...planData };
          plan.status = 'completed';
          plan.aiModel = aiResponse.model;
          plan.tokensUsed = aiResponse.tokensUsed || 0;

          await plan.save();
        })
        .catch(async (error) => {
          console.error('AI Generation Error:', error);
          plan.status = 'failed';
          plan.error = error.message || 'Failed to generate plan';
          await plan.save();
        });

      // Return plan immediately with generating status
      return created(res, 'Plan creation started', { 
        plan: {
          id: plan._id,
          userRequest: plan.userRequest,
          status: plan.status,
          planData: plan.planData
        }
      });
    } else {
      // Synchronous mode - wait for AI response (for direct chat)
      try {
        const aiResponse = await generatePlanWithAI(userRequest, budget, location, categories, groupType);
        
        // Extract structured data
        const planData = extractPlanData(
          aiResponse.plan,
          userRequest,
          budget,
          location,
          categories,
          groupType
        );

        // Update plan with AI response
        plan.generatedPlan = aiResponse.plan;
        plan.planData = { ...plan.planData, ...planData };
        plan.status = 'completed';
        plan.aiModel = aiResponse.model;
        plan.tokensUsed = aiResponse.tokensUsed || 0;

        await plan.save();

        // Return complete plan immediately
        return created(res, 'Plan created successfully', { 
          plan: {
            id: plan._id,
            userRequest: plan.userRequest,
            generatedPlan: plan.generatedPlan,
            status: plan.status,
            planData: plan.planData,
            createdAt: plan.createdAt,
            updatedAt: plan.updatedAt
          }
        });
      } catch (error) {
        console.error('AI Generation Error:', error);
        plan.status = 'failed';
        plan.error = error.message || 'Failed to generate plan';
        await plan.save();

        return serverError(res, 'Failed to generate plan', error);
      }
    }

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Get Plan Status (for polling)
// =============================
exports.getPlanStatus = async (req, res) => {
  try {
    const { planId } = req.params;
    const userId = req.user.id;

    if (!isValidObjectId(planId)) {
      return badRequest(res, 'Invalid plan ID');
    }

    const plan = await Plan.findOne({
      _id: planId,
      user: userId
    });

    if (!plan) {
      return notFound(res, 'Plan not found');
    }

    return ok(res, 'Plan status retrieved', {
      plan: {
        id: plan._id,
        status: plan.status,
        userRequest: plan.userRequest,
        generatedPlan: plan.status === 'completed' ? plan.generatedPlan : null,
        planData: plan.planData,
        error: plan.error,
        createdAt: plan.createdAt,
        updatedAt: plan.updatedAt
      }
    });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Get User Plans
// =============================
exports.getUserPlans = async (req, res) => {
  try {
    const userId = req.user.id;
    const { page, limit } = validatePagination(req.query.page, req.query.limit, 50);
    const { status, isSaved } = req.query;

    // Build query
    const query = {
      user: userId,
      isActive: true
    };

    if (status) {
      query.status = status;
    }

    if (isSaved !== undefined) {
      query.isSaved = isSaved === 'true';
    }

    // Get plans
    const plans = await Plan.find(query)
      .sort({ createdAt: -1 })
      .limit(limit)
      .skip((page - 1) * limit)
      .select('userRequest generatedPlan planData status isSaved createdAt updatedAt');

    const totalPlans = await Plan.countDocuments(query);

    return ok(res, 'Plans retrieved successfully', {
      plans,
      pagination: {
        page,
        limit,
        totalPlans,
        totalPages: Math.ceil(totalPlans / limit)
      }
    });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Get Plan by ID
// =============================
exports.getPlanById = async (req, res) => {
  try {
    const { planId } = req.params;
    const userId = req.user.id;

    if (!isValidObjectId(planId)) {
      return badRequest(res, 'Invalid plan ID');
    }

    const plan = await Plan.findOne({
      _id: planId,
      user: userId,
      isActive: true
    });

    if (!plan) {
      return notFound(res, 'Plan not found');
    }

    return ok(res, 'Plan retrieved successfully', { plan });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Save/Unsave Plan
// =============================
exports.toggleSavePlan = async (req, res) => {
  try {
    const { planId } = req.params;
    const userId = req.user.id;

    if (!isValidObjectId(planId)) {
      return badRequest(res, 'Invalid plan ID');
    }

    const plan = await Plan.findOne({
      _id: planId,
      user: userId,
      isActive: true
    });

    if (!plan) {
      return notFound(res, 'Plan not found');
    }

    plan.isSaved = !plan.isSaved;
    await plan.save();

    return ok(res, `Plan ${plan.isSaved ? 'saved' : 'unsaved'} successfully`, { plan });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Delete Plan
// =============================
exports.deletePlan = async (req, res) => {
  try {
    const { planId } = req.params;
    const userId = req.user.id;

    if (!isValidObjectId(planId)) {
      return badRequest(res, 'Invalid plan ID');
    }

    const plan = await Plan.findOne({
      _id: planId,
      user: userId
    });

    if (!plan) {
      return notFound(res, 'Plan not found');
    }

    plan.isActive = false;
    await plan.save();

    return ok(res, 'Plan deleted successfully');

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Regenerate Plan
// =============================
exports.regeneratePlan = async (req, res) => {
  try {
    const { planId } = req.params;
    const userId = req.user.id;
    const { userRequest, budget, location, categories, groupType } = req.body;

    if (!isValidObjectId(planId)) {
      return badRequest(res, 'Invalid plan ID');
    }

    const plan = await Plan.findOne({
      _id: planId,
      user: userId,
      isActive: true
    });

    if (!plan) {
      return notFound(res, 'Plan not found');
    }

    // Update request if provided
    if (userRequest) {
      plan.userRequest = userRequest.trim();
    }

    // Update plan data if provided
    if (budget !== undefined) plan.planData.budget = budget;
    if (location) plan.planData.location = location;
    if (categories) plan.planData.categories = categories;
    if (groupType) plan.planData.groupType = groupType;

    // Reset status
    plan.status = 'generating';
    plan.generatedPlan = '';
    plan.error = null;

    await plan.save();

    // Regenerate plan with AI
    const request = userRequest || plan.userRequest;
    const planBudget = budget !== undefined ? budget : plan.planData.budget;
    const planLocation = location || plan.planData.location;
    const planCategories = categories || plan.planData.categories;
    const planGroupType = groupType || plan.planData.groupType;

    generatePlanWithAI(request, planBudget, planLocation, planCategories, planGroupType)
      .then(async (aiResponse) => {
        const planData = extractPlanData(
          aiResponse.plan,
          request,
          planBudget,
          planLocation,
          planCategories,
          planGroupType
        );

        plan.generatedPlan = aiResponse.plan;
        plan.planData = { ...plan.planData, ...planData };
        plan.status = 'completed';
        plan.aiModel = aiResponse.model;
        plan.tokensUsed = aiResponse.tokensUsed || 0;
        await plan.save();
      })
      .catch(async (error) => {
        console.error('AI Regeneration Error:', error);
        plan.status = 'failed';
        plan.error = error.message || 'Failed to regenerate plan';
        await plan.save();
      });

    return ok(res, 'Plan regeneration started', {
      plan: {
        id: plan._id,
        status: plan.status,
        userRequest: plan.userRequest,
        planData: plan.planData
      }
    });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

