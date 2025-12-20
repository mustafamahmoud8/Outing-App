const express = require('express');
const router = express.Router();
const {
  getAllCategories,
  getCategoryBySlug,
  getPlacesByCategory,
  searchPlaces,
  getPlaceById,
  initializeCategories
} = require('../controllers/categoryController');

// Public routes (no auth required)
// Note: Order matters! More specific routes first
router.get('/init', initializeCategories); // Initialize categories (one-time setup)
router.get('/places/search', searchPlaces); // Search places (must be before /places/:placeId)
router.get('/places/:placeId', getPlaceById); // Get place by ID
router.get('/:slug/places', getPlacesByCategory); // Get places by category (must be before /:slug)
router.get('/:slug', getCategoryBySlug); // Get category by slug
router.get('/', getAllCategories); // Get all categories (must be last)

module.exports = router;

