const express = require('express');
const router = express.Router();
const budgetController = require('../controllers/budgetController');

/**
 * @route   GET /api/budget/filter
 * @desc    Filter categories and places by user's budget
 * @access  Public
 * @query   budget - The user's budget amount (e.g., ?budget=1000)
 */
router.get('/filter', budgetController.filterByBudget);

/**
 * @route   GET /api/budget/place/:placeId
 * @desc    Get place details with price
 * @access  Public
 * @param   placeId - The place ID
 */
router.get('/place/:placeId', budgetController.getPlaceWithPrice);

/**
 * @route   POST /api/budget/select-place
 * @desc    Select a place with user's current location
 * @access  Public
 * @body    placeId - The place ID
 * @body    currentLocation - { latitude, longitude }
 */
router.post('/select-place', budgetController.selectPlaceWithLocation);

/**
 * @route   POST /api/budget/filter-with-location
 * @desc    Filter places by budget with distance from current location
 * @access  Public
 * @body    budget - The user's budget amount
 * @body    currentLocation - { latitude, longitude }
 * @body    maxDistance - (optional) Maximum distance in meters
 */
router.post('/filter-with-location', budgetController.filterByBudgetWithLocation);

/**
 * @route   GET /api/budget/free-places
 * @desc    Get all free places (price = 0 or null)
 * @access  Public
 * @query   currentLatitude - (optional) User's latitude for distance
 * @query   currentLongitude - (optional) User's longitude for distance
 * @query   categorySlug - (optional) Filter by category
 */
router.get('/free-places', budgetController.getFreePlaces);

/**
 * @route   GET /api/budget/map-places
 * @desc    Get all places with locations for map display
 * @access  Public
 * @query   categorySlug - (optional) Filter by category
 * @query   minPrice - (optional) Minimum price filter
 * @query   maxPrice - (optional) Maximum price filter
 * @query   centerLatitude - (optional) Center point latitude
 * @query   centerLongitude - (optional) Center point longitude
 * @query   radius - (optional) Radius in meters from center
 * @query   limit - (optional) Max number of results (default 100)
 */
router.get('/map-places', budgetController.getMapPlaces);

/**
 * @route   POST /api/budget/nearby-places
 * @desc    Get nearby places from current location
 * @access  Public
 * @body    currentLocation - { latitude, longitude }
 * @body    radius - (optional) Search radius in meters (default 5000)
 * @body    categorySlug - (optional) Filter by category
 * @body    maxPrice - (optional) Maximum price filter
 * @body    limit - (optional) Max number of results (default 50)
 */
router.post('/nearby-places', budgetController.getNearbyPlaces);

module.exports = router;
