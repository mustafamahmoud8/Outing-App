const express = require('express');
const router = express.Router();
const {
  createPlan,
  getPlanStatus,
  getUserPlans,
  getPlanById,
  toggleSavePlan,
  deletePlan,
  regeneratePlan
} = require('../controllers/planController');
const { protect } = require('../middleware/authMiddleware');

// All routes require authentication
router.use(protect);

// Plan routes
router.post('/', createPlan); // Create new AI plan
router.get('/', getUserPlans); // Get all user plans
router.get('/:planId/status', getPlanStatus); // Get plan status (for polling)
router.get('/:planId', getPlanById); // Get plan by ID
router.put('/:planId/save', toggleSavePlan); // Save/unsave plan
router.delete('/:planId', deletePlan); // Delete plan
router.post('/:planId/regenerate', regeneratePlan); // Regenerate plan

module.exports = router;

