const express = require('express');
const router = express.Router();
const engagementController = require('../controllers/engagementController');
// Note: You'll need to import your auth middleware
// const { protect } = require('../middleware/authMiddleware');

/**
 * @route   POST /api/engagements
 * @desc    Create new engagement with time table
 * @access  Private
 */
// router.post('/', protect, engagementController.createEngagement);
router.post('/', engagementController.createEngagement);

/**
 * @route   GET /api/engagements
 * @desc    Get user's engagements
 * @access  Private
 * @query   status - Filter by status (planned, in-progress, completed, cancelled)
 * @query   upcoming - true/false for upcoming engagements only
 */
// router.get('/', protect, engagementController.getUserEngagements);
router.get('/', engagementController.getUserEngagements);

/**
 * @route   GET /api/engagements/:engagementId
 * @desc    Get engagement by ID
 * @access  Private
 */
// router.get('/:engagementId', protect, engagementController.getEngagementById);
router.get('/:engagementId', engagementController.getEngagementById);

/**
 * @route   PUT /api/engagements/:engagementId/status
 * @desc    Update engagement status
 * @access  Private
 */
// router.put('/:engagementId/status', protect, engagementController.updateEngagementStatus);
router.put('/:engagementId/status', engagementController.updateEngagementStatus);

/**
 * @route   POST /api/engagements/:engagementId/request-captain
 * @desc    Request captain/driver service
 * @access  Private
 */
// router.post('/:engagementId/request-captain', protect, engagementController.requestCaptain);
router.post('/:engagementId/request-captain', engagementController.requestCaptain);

/**
 * @route   PUT /api/engagements/:engagementId/assign-captain
 * @desc    Assign captain to engagement (admin/captain app)
 * @access  Private
 */
// router.put('/:engagementId/assign-captain', protect, engagementController.assignCaptain);
router.put('/:engagementId/assign-captain', engagementController.assignCaptain);

/**
 * @route   PUT /api/engagements/:engagementId/live-location
 * @desc    Update live location and sharing settings
 * @access  Private
 */
// router.put('/:engagementId/live-location', protect, engagementController.updateLiveLocation);
router.put('/:engagementId/live-location', engagementController.updateLiveLocation);

/**
 * @route   POST /api/engagements/:engagementId/check-proximity
 * @desc    Check proximity to places and send notifications
 * @access  Private
 */
// router.post('/:engagementId/check-proximity', protect, engagementController.checkProximity);
router.post('/:engagementId/check-proximity', engagementController.checkProximity);

module.exports = router;
