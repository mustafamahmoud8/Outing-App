const axios = require('axios');

// Utils
const { ok, badRequest, serverError } = require('../utils/responseHelper');

// =============================
//     Configuration
// =============================
const API_CONFIG = {
  // Open-Meteo (completely free, no API key needed)
  weather: {
    baseUrl: 'https://api.open-meteo.com/v1',
    geocoding: 'https://geocoding-api.open-meteo.com/v1'
  },
  // ExchangeRate-API (free tier)
  currency: {
    baseUrl: 'https://open.er-api.com/v6/latest'
  },
  // REST Countries (completely free)
  countries: {
    baseUrl: 'https://restcountries.com/v3.1'
  },
  // Random User (completely free)
  randomUser: {
    baseUrl: 'https://randomuser.me/api'
  },
  // Lorem Picsum (completely free)
  images: {
    baseUrl: 'https://picsum.photos'
  },
  // Quotable (completely free)
  quotes: {
    baseUrl: 'https://api.quotable.io'
  },
  // Nager.Date (free public holidays)
  holidays: {
    baseUrl: 'https://date.nager.at/api/v3'
  },
  // IP Geolocation (free tier)
  ipGeo: {
    baseUrl: 'https://ipapi.co'
  },
  // Cat Facts (completely free)
  catFacts: {
    baseUrl: 'https://catfact.ninja'
  },
  // Bored API (completely free)
  bored: {
    baseUrl: 'https://www.boredapi.com/api'
  },
  // Joke API (completely free)
  jokes: {
    baseUrl: 'https://v2.jokeapi.dev'
  },
  // Universities List (completely free)
  universities: {
    baseUrl: 'http://universities.hipolabs.com'
  },
  // Nominatim OpenStreetMap (completely free)
  geocoding: {
    baseUrl: 'https://nominatim.openstreetmap.org'
  },
  // Unsplash Source (completely free, no API key for basic usage)
  unsplash: {
    sourceUrl: 'https://source.unsplash.com'
  },
  // Numbers API (completely free)
  numbers: {
    baseUrl: 'http://numbersapi.com'
  },
  // Advice Slip (completely free)
  advice: {
    baseUrl: 'https://api.adviceslip.com'
  }
};

// Helper function for API calls with timeout
const fetchApi = async (url, options = {}) => {
  try {
    const response = await axios({
      url,
      timeout: 10000, // 10 second timeout
      ...options,
      headers: {
        'User-Agent': 'OutingApp/1.0',
        ...options.headers
      }
    });
    return response.data;
  } catch (error) {
    throw new Error(error.response?.data?.message || error.message);
  }
};

// =============================
//     WEATHER APIs
// =============================

/**
 * Get current weather by coordinates
 * Uses Open-Meteo (completely free, no API key)
 */
exports.getCurrentWeather = async (req, res) => {
  try {
    const { lat, lon, units = 'metric' } = req.query;

    if (!lat || !lon) {
      return badRequest(res, 'Latitude and longitude are required');
    }

    const latitude = parseFloat(lat);
    const longitude = parseFloat(lon);

    if (isNaN(latitude) || isNaN(longitude)) {
      return badRequest(res, 'Invalid coordinates');
    }

    const temperatureUnit = units === 'imperial' ? 'fahrenheit' : 'celsius';
    const windspeedUnit = units === 'imperial' ? 'mph' : 'kmh';

    const url = `${API_CONFIG.weather.baseUrl}/forecast?latitude=${latitude}&longitude=${longitude}&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,rain,weather_code,cloud_cover,wind_speed_10m,wind_direction_10m&temperature_unit=${temperatureUnit}&windspeed_unit=${windspeedUnit}&timezone=auto`;

    const data = await fetchApi(url);

    // Map weather codes to descriptions
    const weatherDescriptions = {
      0: 'Clear sky',
      1: 'Mainly clear',
      2: 'Partly cloudy',
      3: 'Overcast',
      45: 'Fog',
      48: 'Depositing rime fog',
      51: 'Light drizzle',
      53: 'Moderate drizzle',
      55: 'Dense drizzle',
      61: 'Slight rain',
      63: 'Moderate rain',
      65: 'Heavy rain',
      71: 'Slight snow fall',
      73: 'Moderate snow fall',
      75: 'Heavy snow fall',
      77: 'Snow grains',
      80: 'Slight rain showers',
      81: 'Moderate rain showers',
      82: 'Violent rain showers',
      85: 'Slight snow showers',
      86: 'Heavy snow showers',
      95: 'Thunderstorm',
      96: 'Thunderstorm with slight hail',
      99: 'Thunderstorm with heavy hail'
    };

    const current = data.current;
    const weatherCode = current.weather_code;

    return ok(res, 'Weather retrieved successfully', {
      location: {
        latitude: data.latitude,
        longitude: data.longitude,
        timezone: data.timezone,
        elevation: data.elevation
      },
      current: {
        temperature: current.temperature_2m,
        feelsLike: current.apparent_temperature,
        humidity: current.relative_humidity_2m,
        precipitation: current.precipitation,
        rain: current.rain,
        cloudCover: current.cloud_cover,
        windSpeed: current.wind_speed_10m,
        windDirection: current.wind_direction_10m,
        isDay: current.is_day === 1,
        weatherCode: weatherCode,
        description: weatherDescriptions[weatherCode] || 'Unknown',
        icon: current.is_day === 1 ? 'day' : 'night'
      },
      units: {
        temperature: temperatureUnit,
        windSpeed: windspeedUnit
      }
    });

  } catch (error) {
    console.error('Weather API error:', error);
    return serverError(res, 'Failed to fetch weather data', error);
  }
};

/**
 * Get weather forecast (7 days)
 */
exports.getWeatherForecast = async (req, res) => {
  try {
    const { lat, lon, days = 7, units = 'metric' } = req.query;

    if (!lat || !lon) {
      return badRequest(res, 'Latitude and longitude are required');
    }

    const latitude = parseFloat(lat);
    const longitude = parseFloat(lon);
    const forecastDays = Math.min(Math.max(parseInt(days), 1), 16);

    const temperatureUnit = units === 'imperial' ? 'fahrenheit' : 'celsius';

    const url = `${API_CONFIG.weather.baseUrl}/forecast?latitude=${latitude}&longitude=${longitude}&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,rain_sum,weather_code,sunrise,sunset,uv_index_max&temperature_unit=${temperatureUnit}&timezone=auto&forecast_days=${forecastDays}`;

    const data = await fetchApi(url);

    const weatherDescriptions = {
      0: 'Clear sky', 1: 'Mainly clear', 2: 'Partly cloudy', 3: 'Overcast',
      45: 'Fog', 48: 'Rime fog', 51: 'Light drizzle', 53: 'Drizzle', 55: 'Dense drizzle',
      61: 'Slight rain', 63: 'Rain', 65: 'Heavy rain', 71: 'Light snow', 73: 'Snow', 75: 'Heavy snow',
      80: 'Rain showers', 81: 'Moderate showers', 82: 'Heavy showers', 95: 'Thunderstorm'
    };

    const daily = data.daily;
    const forecast = daily.time.map((date, index) => ({
      date: date,
      temperatureMax: daily.temperature_2m_max[index],
      temperatureMin: daily.temperature_2m_min[index],
      precipitation: daily.precipitation_sum[index],
      rain: daily.rain_sum[index],
      weatherCode: daily.weather_code[index],
      description: weatherDescriptions[daily.weather_code[index]] || 'Unknown',
      sunrise: daily.sunrise[index],
      sunset: daily.sunset[index],
      uvIndex: daily.uv_index_max[index]
    }));

    return ok(res, 'Forecast retrieved successfully', {
      location: {
        latitude: data.latitude,
        longitude: data.longitude,
        timezone: data.timezone
      },
      forecast: forecast
    });

  } catch (error) {
    console.error('Forecast API error:', error);
    return serverError(res, 'Failed to fetch forecast data', error);
  }
};

/**
 * Search location by name (Geocoding)
 */
exports.searchLocation = async (req, res) => {
  try {
    const { query, limit = 5 } = req.query;

    if (!query) {
      return badRequest(res, 'Search query is required');
    }

    const url = `${API_CONFIG.weather.geocoding}/search?name=${encodeURIComponent(query)}&count=${limit}&language=en&format=json`;

    const data = await fetchApi(url);

    if (!data.results || data.results.length === 0) {
      return ok(res, 'No locations found', { locations: [] });
    }

    const locations = data.results.map(loc => ({
      id: loc.id,
      name: loc.name,
      country: loc.country,
      countryCode: loc.country_code,
      admin1: loc.admin1, // State/Province
      admin2: loc.admin2, // County/District
      latitude: loc.latitude,
      longitude: loc.longitude,
      elevation: loc.elevation,
      population: loc.population,
      timezone: loc.timezone
    }));

    return ok(res, 'Locations found', { locations });

  } catch (error) {
    console.error('Geocoding API error:', error);
    return serverError(res, 'Failed to search location', error);
  }
};

// =============================
//     CURRENCY APIs
// =============================

/**
 * Get currency exchange rates
 */
exports.getExchangeRates = async (req, res) => {
  try {
    const { base = 'USD' } = req.query;

    const url = `${API_CONFIG.currency.baseUrl}/${base.toUpperCase()}`;
    const data = await fetchApi(url);

    return ok(res, 'Exchange rates retrieved successfully', {
      base: data.base_code,
      lastUpdated: data.time_last_update_utc,
      nextUpdate: data.time_next_update_utc,
      rates: data.rates
    });

  } catch (error) {
    console.error('Currency API error:', error);
    return serverError(res, 'Failed to fetch exchange rates', error);
  }
};

/**
 * Convert currency
 */
exports.convertCurrency = async (req, res) => {
  try {
    const { amount, from = 'USD', to = 'EGP' } = req.query;

    if (!amount) {
      return badRequest(res, 'Amount is required');
    }

    const numAmount = parseFloat(amount);
    if (isNaN(numAmount)) {
      return badRequest(res, 'Invalid amount');
    }

    const url = `${API_CONFIG.currency.baseUrl}/${from.toUpperCase()}`;
    const data = await fetchApi(url);

    const rate = data.rates[to.toUpperCase()];
    if (!rate) {
      return badRequest(res, `Currency ${to} not found`);
    }

    const converted = numAmount * rate;

    return ok(res, 'Currency converted successfully', {
      from: {
        currency: from.toUpperCase(),
        amount: numAmount
      },
      to: {
        currency: to.toUpperCase(),
        amount: Math.round(converted * 100) / 100,
        rate: rate
      },
      lastUpdated: data.time_last_update_utc
    });

  } catch (error) {
    console.error('Currency conversion error:', error);
    return serverError(res, 'Failed to convert currency', error);
  }
};

// =============================
//     COUNTRIES APIs
// =============================

/**
 * Get all countries
 */
exports.getAllCountries = async (req, res) => {
  try {
    const { fields } = req.query;

    let url = `${API_CONFIG.countries.baseUrl}/all`;
    if (fields) {
      url += `?fields=${fields}`;
    }

    const data = await fetchApi(url);

    const countries = data.map(country => ({
      name: country.name?.common,
      officialName: country.name?.official,
      capital: country.capital?.[0],
      region: country.region,
      subregion: country.subregion,
      population: country.population,
      area: country.area,
      flag: country.flags?.svg || country.flags?.png,
      flagEmoji: country.flag,
      currencies: country.currencies,
      languages: country.languages,
      timezones: country.timezones,
      borders: country.borders,
      cca2: country.cca2,
      cca3: country.cca3,
      callingCode: country.idd?.root + (country.idd?.suffixes?.[0] || '')
    }));

    return ok(res, 'Countries retrieved successfully', {
      count: countries.length,
      countries: countries
    });

  } catch (error) {
    console.error('Countries API error:', error);
    return serverError(res, 'Failed to fetch countries', error);
  }
};

/**
 * Get country by name
 */
exports.getCountryByName = async (req, res) => {
  try {
    const { name } = req.params;

    if (!name) {
      return badRequest(res, 'Country name is required');
    }

    const url = `${API_CONFIG.countries.baseUrl}/name/${encodeURIComponent(name)}`;
    const data = await fetchApi(url);

    if (!data || data.length === 0) {
      return ok(res, 'Country not found', { country: null });
    }

    const country = data[0];

    return ok(res, 'Country found', {
      country: {
        name: country.name?.common,
        officialName: country.name?.official,
        nativeName: country.name?.nativeName,
        capital: country.capital,
        region: country.region,
        subregion: country.subregion,
        population: country.population,
        area: country.area,
        flag: country.flags?.svg || country.flags?.png,
        flagEmoji: country.flag,
        coatOfArms: country.coatOfArms?.svg,
        currencies: country.currencies,
        languages: country.languages,
        timezones: country.timezones,
        borders: country.borders,
        latlng: country.latlng,
        landlocked: country.landlocked,
        maps: country.maps,
        gini: country.gini,
        car: country.car
      }
    });

  } catch (error) {
    console.error('Country API error:', error);
    return serverError(res, 'Failed to fetch country', error);
  }
};

/**
 * Get countries by region
 */
exports.getCountriesByRegion = async (req, res) => {
  try {
    const { region } = req.params;

    if (!region) {
      return badRequest(res, 'Region is required');
    }

    const validRegions = ['africa', 'americas', 'asia', 'europe', 'oceania'];
    if (!validRegions.includes(region.toLowerCase())) {
      return badRequest(res, `Invalid region. Valid regions: ${validRegions.join(', ')}`);
    }

    const url = `${API_CONFIG.countries.baseUrl}/region/${region}`;
    const data = await fetchApi(url);

    const countries = data.map(country => ({
      name: country.name?.common,
      capital: country.capital?.[0],
      flag: country.flags?.svg,
      flagEmoji: country.flag,
      population: country.population,
      cca2: country.cca2
    }));

    return ok(res, 'Countries retrieved successfully', {
      region: region,
      count: countries.length,
      countries: countries
    });

  } catch (error) {
    console.error('Region API error:', error);
    return serverError(res, 'Failed to fetch countries by region', error);
  }
};

// =============================
//     HOLIDAYS APIs
// =============================

/**
 * Get public holidays by country and year
 */
exports.getPublicHolidays = async (req, res) => {
  try {
    const { country = 'EG', year = new Date().getFullYear() } = req.query;

    const url = `${API_CONFIG.holidays.baseUrl}/PublicHolidays/${year}/${country.toUpperCase()}`;
    const data = await fetchApi(url);

    const holidays = data.map(holiday => ({
      date: holiday.date,
      name: holiday.localName,
      nameEn: holiday.name,
      countryCode: holiday.countryCode,
      fixed: holiday.fixed,
      global: holiday.global,
      counties: holiday.counties,
      types: holiday.types
    }));

    return ok(res, 'Holidays retrieved successfully', {
      country: country.toUpperCase(),
      year: parseInt(year),
      count: holidays.length,
      holidays: holidays
    });

  } catch (error) {
    console.error('Holidays API error:', error);
    return serverError(res, 'Failed to fetch holidays', error);
  }
};

/**
 * Get upcoming holidays
 */
exports.getUpcomingHolidays = async (req, res) => {
  try {
    const { country = 'EG' } = req.query;

    const url = `${API_CONFIG.holidays.baseUrl}/NextPublicHolidays/${country.toUpperCase()}`;
    const data = await fetchApi(url);

    const holidays = data.slice(0, 10).map(holiday => ({
      date: holiday.date,
      name: holiday.localName,
      nameEn: holiday.name,
      daysUntil: Math.ceil((new Date(holiday.date) - new Date()) / (1000 * 60 * 60 * 24))
    }));

    return ok(res, 'Upcoming holidays retrieved', {
      country: country.toUpperCase(),
      holidays: holidays
    });

  } catch (error) {
    console.error('Upcoming holidays API error:', error);
    return serverError(res, 'Failed to fetch upcoming holidays', error);
  }
};

/**
 * Get available countries for holiday API
 */
exports.getHolidayCountries = async (req, res) => {
  try {
    const url = `${API_CONFIG.holidays.baseUrl}/AvailableCountries`;
    const data = await fetchApi(url);

    return ok(res, 'Countries retrieved successfully', {
      count: data.length,
      countries: data
    });

  } catch (error) {
    console.error('Holiday countries API error:', error);
    return serverError(res, 'Failed to fetch countries', error);
  }
};

// =============================
//     QUOTES APIs
// =============================

/**
 * Get random quote
 */
exports.getRandomQuote = async (req, res) => {
  try {
    const url = `${API_CONFIG.quotes.baseUrl}/random`;
    const data = await fetchApi(url);

    return ok(res, 'Quote retrieved successfully', {
      quote: {
        id: data._id,
        content: data.content,
        author: data.author,
        authorSlug: data.authorSlug,
        tags: data.tags,
        length: data.length
      }
    });

  } catch (error) {
    console.error('Quote API error:', error);
    return serverError(res, 'Failed to fetch quote', error);
  }
};

/**
 * Get quotes by tag
 */
exports.getQuotesByTag = async (req, res) => {
  try {
    const { tag } = req.params;
    const { limit = 10, page = 1 } = req.query;

    if (!tag) {
      return badRequest(res, 'Tag is required');
    }

    const url = `${API_CONFIG.quotes.baseUrl}/quotes?tags=${encodeURIComponent(tag)}&limit=${limit}&page=${page}`;
    const data = await fetchApi(url);

    return ok(res, 'Quotes retrieved successfully', {
      tag: tag,
      count: data.count,
      totalCount: data.totalCount,
      page: data.page,
      totalPages: data.totalPages,
      quotes: data.results.map(q => ({
        id: q._id,
        content: q.content,
        author: q.author,
        tags: q.tags
      }))
    });

  } catch (error) {
    console.error('Quotes by tag API error:', error);
    return serverError(res, 'Failed to fetch quotes', error);
  }
};

/**
 * Get all quote tags
 */
exports.getQuoteTags = async (req, res) => {
  try {
    const url = `${API_CONFIG.quotes.baseUrl}/tags`;
    const data = await fetchApi(url);

    return ok(res, 'Tags retrieved successfully', {
      count: data.length,
      tags: data.map(tag => ({
        id: tag._id,
        name: tag.name,
        slug: tag.slug,
        quoteCount: tag.quoteCount
      }))
    });

  } catch (error) {
    console.error('Quote tags API error:', error);
    return serverError(res, 'Failed to fetch tags', error);
  }
};

// =============================
//     FUN FACTS APIs
// =============================

/**
 * Get random cat fact
 */
exports.getCatFact = async (req, res) => {
  try {
    const url = `${API_CONFIG.catFacts.baseUrl}/fact`;
    const data = await fetchApi(url);

    return ok(res, 'Cat fact retrieved', {
      fact: data.fact,
      length: data.length
    });

  } catch (error) {
    console.error('Cat fact API error:', error);
    return serverError(res, 'Failed to fetch cat fact', error);
  }
};

/**
 * Get random activity suggestion (bored API)
 */
exports.getRandomActivity = async (req, res) => {
  try {
    const { type, participants, price } = req.query;

    let url = `${API_CONFIG.bored.baseUrl}/activity`;
    const params = [];

    if (type) params.push(`type=${type}`);
    if (participants) params.push(`participants=${participants}`);
    if (price) params.push(`price=${price}`);

    if (params.length > 0) {
      url += '?' + params.join('&');
    }

    const data = await fetchApi(url);

    if (data.error) {
      return ok(res, 'No activity found with those filters', { activity: null });
    }

    return ok(res, 'Activity suggestion retrieved', {
      activity: {
        name: data.activity,
        type: data.type,
        participants: data.participants,
        price: data.price,
        accessibility: data.accessibility,
        key: data.key,
        link: data.link || null
      }
    });

  } catch (error) {
    console.error('Bored API error:', error);
    return serverError(res, 'Failed to fetch activity', error);
  }
};

/**
 * Get random joke
 */
exports.getRandomJoke = async (req, res) => {
  try {
    const { category = 'Any', type = 'single,twopart', safe = 'true' } = req.query;

    let url = `${API_CONFIG.jokes.baseUrl}/joke/${category}?type=${type}`;

    if (safe === 'true') {
      url += '&safe-mode';
    }

    const data = await fetchApi(url);

    if (data.error) {
      return badRequest(res, data.message || 'Failed to get joke');
    }

    let joke;
    if (data.type === 'single') {
      joke = {
        type: 'single',
        joke: data.joke
      };
    } else {
      joke = {
        type: 'twopart',
        setup: data.setup,
        delivery: data.delivery
      };
    }

    return ok(res, 'Joke retrieved', {
      joke: {
        ...joke,
        category: data.category,
        flags: data.flags,
        id: data.id,
        lang: data.lang
      }
    });

  } catch (error) {
    console.error('Joke API error:', error);
    return serverError(res, 'Failed to fetch joke', error);
  }
};

/**
 * Get number fact
 */
exports.getNumberFact = async (req, res) => {
  try {
    const { number = 'random', type = 'trivia' } = req.query;

    const validTypes = ['trivia', 'math', 'date', 'year'];
    if (!validTypes.includes(type)) {
      return badRequest(res, `Invalid type. Valid types: ${validTypes.join(', ')}`);
    }

    const url = `${API_CONFIG.numbers.baseUrl}/${number}/${type}?json`;
    const data = await fetchApi(url);

    return ok(res, 'Number fact retrieved', {
      number: data.number,
      type: data.type,
      fact: data.text,
      found: data.found
    });

  } catch (error) {
    console.error('Number fact API error:', error);
    return serverError(res, 'Failed to fetch number fact', error);
  }
};

/**
 * Get random advice
 */
exports.getRandomAdvice = async (req, res) => {
  try {
    const url = `${API_CONFIG.advice.baseUrl}/advice`;
    const data = await fetchApi(url);

    return ok(res, 'Advice retrieved', {
      advice: {
        id: data.slip.id,
        text: data.slip.advice
      }
    });

  } catch (error) {
    console.error('Advice API error:', error);
    return serverError(res, 'Failed to fetch advice', error);
  }
};

// =============================
//     GEOCODING APIs
// =============================

/**
 * Search address (forward geocoding)
 */
exports.searchAddress = async (req, res) => {
  try {
    const { query, limit = 5 } = req.query;

    if (!query) {
      return badRequest(res, 'Search query is required');
    }

    const url = `${API_CONFIG.geocoding.baseUrl}/search?q=${encodeURIComponent(query)}&format=json&limit=${limit}&addressdetails=1`;
    const data = await fetchApi(url);

    if (!data || data.length === 0) {
      return ok(res, 'No results found', { results: [] });
    }

    const results = data.map(item => ({
      displayName: item.display_name,
      latitude: parseFloat(item.lat),
      longitude: parseFloat(item.lon),
      type: item.type,
      class: item.class,
      importance: item.importance,
      address: {
        road: item.address?.road,
        city: item.address?.city || item.address?.town || item.address?.village,
        state: item.address?.state,
        country: item.address?.country,
        countryCode: item.address?.country_code,
        postcode: item.address?.postcode
      },
      boundingBox: item.boundingbox
    }));

    return ok(res, 'Address search completed', { results });

  } catch (error) {
    console.error('Geocoding search error:', error);
    return serverError(res, 'Failed to search address', error);
  }
};

/**
 * Reverse geocoding (coordinates to address)
 */
exports.reverseGeocode = async (req, res) => {
  try {
    const { lat, lon } = req.query;

    if (!lat || !lon) {
      return badRequest(res, 'Latitude and longitude are required');
    }

    const url = `${API_CONFIG.geocoding.baseUrl}/reverse?lat=${lat}&lon=${lon}&format=json&addressdetails=1`;
    const data = await fetchApi(url);

    if (!data || data.error) {
      return ok(res, 'No address found for these coordinates', { address: null });
    }

    return ok(res, 'Address found', {
      address: {
        displayName: data.display_name,
        road: data.address?.road,
        houseNumber: data.address?.house_number,
        suburb: data.address?.suburb,
        city: data.address?.city || data.address?.town || data.address?.village,
        state: data.address?.state,
        country: data.address?.country,
        countryCode: data.address?.country_code,
        postcode: data.address?.postcode
      },
      location: {
        latitude: parseFloat(data.lat),
        longitude: parseFloat(data.lon)
      }
    });

  } catch (error) {
    console.error('Reverse geocoding error:', error);
    return serverError(res, 'Failed to reverse geocode', error);
  }
};

// =============================
//     UNIVERSITIES APIs
// =============================

/**
 * Search universities by country
 */
exports.getUniversities = async (req, res) => {
  try {
    const { country = 'Egypt', name } = req.query;

    let url = `${API_CONFIG.universities.baseUrl}/search?country=${encodeURIComponent(country)}`;

    if (name) {
      url += `&name=${encodeURIComponent(name)}`;
    }

    const data = await fetchApi(url);

    const universities = data.map(uni => ({
      name: uni.name,
      country: uni.country,
      countryCode: uni.alpha_two_code,
      stateProvince: uni['state-province'],
      domains: uni.domains,
      webPages: uni.web_pages
    }));

    return ok(res, 'Universities retrieved', {
      country: country,
      count: universities.length,
      universities: universities
    });

  } catch (error) {
    console.error('Universities API error:', error);
    return serverError(res, 'Failed to fetch universities', error);
  }
};

// =============================
//     RANDOM DATA APIs
// =============================

/**
 * Get random user data
 */
exports.getRandomUser = async (req, res) => {
  try {
    const { results = 1, gender, nat } = req.query;

    let url = `${API_CONFIG.randomUser.baseUrl}/?results=${Math.min(parseInt(results), 50)}`;

    if (gender) url += `&gender=${gender}`;
    if (nat) url += `&nat=${nat}`;

    const data = await fetchApi(url);

    const users = data.results.map(user => ({
      gender: user.gender,
      name: {
        title: user.name.title,
        first: user.name.first,
        last: user.name.last,
        full: `${user.name.first} ${user.name.last}`
      },
      email: user.email,
      phone: user.phone,
      cell: user.cell,
      picture: {
        large: user.picture.large,
        medium: user.picture.medium,
        thumbnail: user.picture.thumbnail
      },
      location: {
        street: `${user.location.street.number} ${user.location.street.name}`,
        city: user.location.city,
        state: user.location.state,
        country: user.location.country,
        postcode: user.location.postcode,
        coordinates: {
          latitude: user.location.coordinates.latitude,
          longitude: user.location.coordinates.longitude
        }
      },
      dob: {
        date: user.dob.date,
        age: user.dob.age
      },
      nationality: user.nat
    }));

    return ok(res, 'Random user(s) generated', {
      count: users.length,
      users: users
    });

  } catch (error) {
    console.error('Random user API error:', error);
    return serverError(res, 'Failed to generate random user', error);
  }
};

/**
 * Get random placeholder image URL
 */
exports.getRandomImage = async (req, res) => {
  try {
    const { width = 800, height = 600, grayscale = 'false', blur } = req.query;

    let url = `${API_CONFIG.images.baseUrl}/${width}/${height}`;

    if (grayscale === 'true') {
      url += '?grayscale';
    }

    if (blur) {
      url += grayscale === 'true' ? '&' : '?';
      url += `blur=${Math.min(Math.max(parseInt(blur), 1), 10)}`;
    }

    // Get multiple random image URLs
    const images = [];
    for (let i = 0; i < 5; i++) {
      images.push({
        url: `${API_CONFIG.images.baseUrl}/seed/${Date.now() + i}/${width}/${height}`,
        width: parseInt(width),
        height: parseInt(height)
      });
    }

    return ok(res, 'Image URLs generated', {
      randomUrl: url,
      images: images,
      info: {
        provider: 'Lorem Picsum',
        note: 'These URLs return different random images each time'
      }
    });

  } catch (error) {
    console.error('Image API error:', error);
    return serverError(res, 'Failed to generate image URL', error);
  }
};

// =============================
//     IP GEOLOCATION
// =============================

/**
 * Get location from IP address
 */
exports.getIpLocation = async (req, res) => {
  try {
    const { ip } = req.query;

    // If no IP provided, get client's IP info
    const url = ip
      ? `${API_CONFIG.ipGeo.baseUrl}/${ip}/json/`
      : `${API_CONFIG.ipGeo.baseUrl}/json/`;

    const data = await fetchApi(url);

    if (data.error) {
      return badRequest(res, data.reason || 'Invalid IP address');
    }

    return ok(res, 'IP location retrieved', {
      ip: data.ip,
      version: data.version,
      city: data.city,
      region: data.region,
      regionCode: data.region_code,
      country: data.country_name,
      countryCode: data.country_code,
      continent: data.continent_code,
      latitude: data.latitude,
      longitude: data.longitude,
      timezone: data.timezone,
      utcOffset: data.utc_offset,
      currency: data.currency,
      currencyName: data.currency_name,
      languages: data.languages,
      asn: data.asn,
      org: data.org
    });

  } catch (error) {
    console.error('IP Geolocation error:', error);
    return serverError(res, 'Failed to get IP location', error);
  }
};

// =============================
//     AGGREGATE ENDPOINTS
// =============================

/**
 * Get daily inspiration (quote + advice + activity)
 */
exports.getDailyInspiration = async (req, res) => {
  try {
    // Fetch all in parallel
    const [quoteRes, adviceRes, activityRes] = await Promise.allSettled([
      fetchApi(`${API_CONFIG.quotes.baseUrl}/random`),
      fetchApi(`${API_CONFIG.advice.baseUrl}/advice`),
      fetchApi(`${API_CONFIG.bored.baseUrl}/activity`)
    ]);

    const result = {
      quote: quoteRes.status === 'fulfilled' ? {
        content: quoteRes.value.content,
        author: quoteRes.value.author
      } : null,
      advice: adviceRes.status === 'fulfilled' ? adviceRes.value.slip.advice : null,
      activity: activityRes.status === 'fulfilled' ? {
        name: activityRes.value.activity,
        type: activityRes.value.type
      } : null
    };

    return ok(res, 'Daily inspiration retrieved', result);

  } catch (error) {
    console.error('Daily inspiration error:', error);
    return serverError(res, 'Failed to fetch daily inspiration', error);
  }
};

/**
 * Get Egypt-specific data (weather + holidays + universities)
 */
exports.getEgyptData = async (req, res) => {
  try {
    const currentYear = new Date().getFullYear();

    // Cairo coordinates
    const cairoLat = 30.0444;
    const cairoLon = 31.2357;

    // Fetch all Egypt data in parallel
    const [weatherRes, holidaysRes, universitiesRes] = await Promise.allSettled([
      fetchApi(`${API_CONFIG.weather.baseUrl}/forecast?latitude=${cairoLat}&longitude=${cairoLon}&current=temperature_2m,weather_code&timezone=auto`),
      fetchApi(`${API_CONFIG.holidays.baseUrl}/NextPublicHolidays/EG`),
      fetchApi(`${API_CONFIG.universities.baseUrl}/search?country=Egypt`)
    ]);

    const result = {
      weather: weatherRes.status === 'fulfilled' ? {
        location: 'Cairo',
        temperature: weatherRes.value.current?.temperature_2m,
        unit: '°C'
      } : null,
      upcomingHolidays: holidaysRes.status === 'fulfilled'
        ? holidaysRes.value.slice(0, 5).map(h => ({
            date: h.date,
            name: h.localName,
            nameEn: h.name
          }))
        : [],
      universitiesCount: universitiesRes.status === 'fulfilled'
        ? universitiesRes.value.length
        : null,
      countryInfo: {
        name: 'Egypt',
        nameAr: 'مصر',
        capital: 'Cairo',
        currency: 'EGP',
        timezone: 'Africa/Cairo'
      }
    };

    return ok(res, 'Egypt data retrieved', result);

  } catch (error) {
    console.error('Egypt data error:', error);
    return serverError(res, 'Failed to fetch Egypt data', error);
  }
};

/**
 * Get available external API services info
 */
exports.getApiInfo = async (req, res) => {
  try {
    const services = [
      {
        name: 'Weather',
        provider: 'Open-Meteo',
        endpoints: ['/weather/current', '/weather/forecast', '/weather/search-location'],
        free: true,
        rateLimit: 'Unlimited'
      },
      {
        name: 'Currency',
        provider: 'ExchangeRate-API',
        endpoints: ['/currency/rates', '/currency/convert'],
        free: true,
        rateLimit: '1500/month'
      },
      {
        name: 'Countries',
        provider: 'REST Countries',
        endpoints: ['/countries', '/countries/:name', '/countries/region/:region'],
        free: true,
        rateLimit: 'Unlimited'
      },
      {
        name: 'Holidays',
        provider: 'Nager.Date',
        endpoints: ['/holidays', '/holidays/upcoming', '/holidays/countries'],
        free: true,
        rateLimit: 'Unlimited'
      },
      {
        name: 'Quotes',
        provider: 'Quotable',
        endpoints: ['/quotes/random', '/quotes/tags/:tag', '/quotes/tags'],
        free: true,
        rateLimit: 'Unlimited'
      },
      {
        name: 'Fun',
        provider: 'Various',
        endpoints: ['/fun/cat-fact', '/fun/activity', '/fun/joke', '/fun/number-fact', '/fun/advice'],
        free: true,
        rateLimit: 'Varies'
      },
      {
        name: 'Geocoding',
        provider: 'OpenStreetMap Nominatim',
        endpoints: ['/geo/search', '/geo/reverse'],
        free: true,
        rateLimit: '1 req/sec'
      },
      {
        name: 'Universities',
        provider: 'Hipolabs',
        endpoints: ['/universities'],
        free: true,
        rateLimit: 'Unlimited'
      },
      {
        name: 'Random Data',
        provider: 'Various',
        endpoints: ['/random/user', '/random/image', '/random/ip-location'],
        free: true,
        rateLimit: 'Unlimited'
      },
      {
        name: 'Aggregate',
        provider: 'Outing App',
        endpoints: ['/daily-inspiration', '/egypt-data'],
        free: true,
        rateLimit: 'N/A'
      }
    ];

    return ok(res, 'External API services info', {
      totalServices: services.length,
      services: services,
      note: 'All APIs are completely free and require no API keys'
    });

  } catch (error) {
    console.error('API info error:', error);
    return serverError(res, 'Failed to get API info', error);
  }
};
