const express = require('express');
const router = express.Router();
const externalApisController = require('../controllers/externalApisController');

// Optional auth middleware (some endpoints might need authentication)
// const { protect } = require('../middleware/authMiddleware');

// =============================
//     WEATHER ROUTES
// =============================

// GET /api/external/weather/current - Get current weather by coordinates
// Query: lat, lon, units (metric/imperial)
router.get('/weather/current', externalApisController.getCurrentWeather);

// GET /api/external/weather/forecast - Get weather forecast
// Query: lat, lon, days (1-16), units
router.get('/weather/forecast', externalApisController.getWeatherForecast);

// GET /api/external/weather/search-location - Search location by name
// Query: query, limit
router.get('/weather/search-location', externalApisController.searchLocation);

// =============================
//     CURRENCY ROUTES
// =============================

// GET /api/external/currency/rates - Get exchange rates
// Query: base (default: USD)
router.get('/currency/rates', externalApisController.getExchangeRates);

// GET /api/external/currency/convert - Convert currency
// Query: amount, from, to
router.get('/currency/convert', externalApisController.convertCurrency);

// =============================
//     COUNTRIES ROUTES
// =============================

// GET /api/external/countries - Get all countries
// Query: fields (optional filter)
router.get('/countries', externalApisController.getAllCountries);

// GET /api/external/countries/region/:region - Get countries by region
// Params: region (africa, americas, asia, europe, oceania)
router.get('/countries/region/:region', externalApisController.getCountriesByRegion);

// GET /api/external/countries/:name - Get country by name
// Params: name
router.get('/countries/:name', externalApisController.getCountryByName);

// =============================
//     HOLIDAYS ROUTES
// =============================

// GET /api/external/holidays - Get public holidays
// Query: country (default: EG), year
router.get('/holidays', externalApisController.getPublicHolidays);

// GET /api/external/holidays/upcoming - Get upcoming holidays
// Query: country (default: EG)
router.get('/holidays/upcoming', externalApisController.getUpcomingHolidays);

// GET /api/external/holidays/countries - Get available countries
router.get('/holidays/countries', externalApisController.getHolidayCountries);

// =============================
//     QUOTES ROUTES
// =============================

// GET /api/external/quotes/random - Get random quote
router.get('/quotes/random', externalApisController.getRandomQuote);

// GET /api/external/quotes/tags - Get all quote tags
router.get('/quotes/tags', externalApisController.getQuoteTags);

// GET /api/external/quotes/tags/:tag - Get quotes by tag
// Query: limit, page
router.get('/quotes/tags/:tag', externalApisController.getQuotesByTag);

// =============================
//     FUN/ENTERTAINMENT ROUTES
// =============================

// GET /api/external/fun/cat-fact - Get random cat fact
router.get('/fun/cat-fact', externalApisController.getCatFact);

// GET /api/external/fun/activity - Get random activity suggestion
// Query: type, participants, price
router.get('/fun/activity', externalApisController.getRandomActivity);

// GET /api/external/fun/joke - Get random joke
// Query: category, type, safe
router.get('/fun/joke', externalApisController.getRandomJoke);

// GET /api/external/fun/number-fact - Get number fact
// Query: number, type (trivia/math/date/year)
router.get('/fun/number-fact', externalApisController.getNumberFact);

// GET /api/external/fun/advice - Get random advice
router.get('/fun/advice', externalApisController.getRandomAdvice);

// =============================
//     GEOCODING ROUTES
// =============================

// GET /api/external/geo/search - Search address (forward geocoding)
// Query: query, limit
router.get('/geo/search', externalApisController.searchAddress);

// GET /api/external/geo/reverse - Reverse geocoding (coordinates to address)
// Query: lat, lon
router.get('/geo/reverse', externalApisController.reverseGeocode);

// =============================
//     UNIVERSITIES ROUTES
// =============================

// GET /api/external/universities - Search universities
// Query: country (default: Egypt), name
router.get('/universities', externalApisController.getUniversities);

// =============================
//     RANDOM DATA ROUTES
// =============================

// GET /api/external/random/user - Get random user data
// Query: results, gender, nat
router.get('/random/user', externalApisController.getRandomUser);

// GET /api/external/random/image - Get random placeholder image URLs
// Query: width, height, grayscale, blur
router.get('/random/image', externalApisController.getRandomImage);

// GET /api/external/random/ip-location - Get location from IP
// Query: ip (optional, defaults to client IP)
router.get('/random/ip-location', externalApisController.getIpLocation);

// =============================
//     AGGREGATE ROUTES
// =============================

// GET /api/external/daily-inspiration - Get daily inspiration (quote + advice + activity)
router.get('/daily-inspiration', externalApisController.getDailyInspiration);

// GET /api/external/egypt-data - Get Egypt-specific data
router.get('/egypt-data', externalApisController.getEgyptData);

// GET /api/external/info - Get available API services info
router.get('/info', externalApisController.getApiInfo);

module.exports = router;
