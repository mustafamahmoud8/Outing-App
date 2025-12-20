const Place = require('../models/Place');
const Category = require('../models/Category');

/**
 * Filter categories and places by user's budget
 * GET /api/budget/filter?budget=1000
 */
exports.filterByBudget = async (req, res) => {
  try {
    const { budget } = req.query;

    // Validate budget parameter
    if (!budget || isNaN(budget) || parseFloat(budget) <= 0) {
      return res.status(400).json({
        success: false,
        message: 'Please provide a valid budget value'
      });
    }

    const userBudget = parseFloat(budget);

    // Find all places where price <= user's budget and is active
    const affordablePlaces = await Place.find({
      price: { $lte: userBudget, $ne: null },
      isActive: true
    })
      .populate('category')
      .select('name price category categorySlug address city description images rating ratingCount');

    if (affordablePlaces.length === 0) {
      return res.status(200).json({
        success: true,
        message: 'No places found within your budget',
        budget: userBudget,
        data: {
          categories: [],
          totalPlaces: 0
        }
      });
    }

    // Group places by category
    const categoriesMap = {};

    affordablePlaces.forEach(place => {
      const categoryId = place.category._id.toString();

      if (!categoriesMap[categoryId]) {
        categoriesMap[categoryId] = {
          _id: place.category._id,
          nameAr: place.category.nameAr,
          nameEn: place.category.nameEn,
          slug: place.category.slug,
          icon: place.category.icon,
          image: place.category.image,
          color: place.category.color,
          description: place.category.description,
          places: []
        };
      }

      categoriesMap[categoryId].places.push({
        _id: place._id,
        name: place.name,
        price: place.price,
        address: place.address,
        city: place.city,
        description: place.description,
        images: place.images,
        rating: place.rating,
        ratingCount: place.ratingCount
      });
    });

    // Convert map to array and sort by category order
    const categories = Object.values(categoriesMap);

    return res.status(200).json({
      success: true,
      message: `Found ${affordablePlaces.length} places within your budget`,
      budget: userBudget,
      data: {
        categories: categories,
        totalPlaces: affordablePlaces.length,
        totalCategories: categories.length
      }
    });

  } catch (error) {
    console.error('Budget filter error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while filtering by budget',
      error: error.message
    });
  }
};

/**
 * Get place details with price
 * GET /api/budget/place/:placeId
 */
exports.getPlaceWithPrice = async (req, res) => {
  try {
    const { placeId } = req.params;

    const place = await Place.findById(placeId)
      .populate('category', 'nameAr nameEn slug icon color')
      .populate('owner', 'name email phone');

    if (!place) {
      return res.status(404).json({
        success: false,
        message: 'Place not found'
      });
    }

    if (!place.isActive) {
      return res.status(400).json({
        success: false,
        message: 'This place is currently not available'
      });
    }

    return res.status(200).json({
      success: true,
      data: {
        place: {
          _id: place._id,
          name: place.name,
          price: place.price,
          priceRange: place.priceRange,
          category: place.category,
          address: place.address,
          phone: place.phone,
          city: place.city,
          description: place.description,
          images: place.images,
          rating: place.rating,
          ratingCount: place.ratingCount,
          workingHours: place.workingHours,
          features: place.features,
          location: place.location,
          owner: place.owner
        }
      }
    });

  } catch (error) {
    console.error('Get place error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while fetching place',
      error: error.message
    });
  }
};

/**
 * Select a place with user's current location
 * POST /api/budget/select-place
 * Returns place details with distance from current location
 */
exports.selectPlaceWithLocation = async (req, res) => {
  try {
    const { placeId, currentLocation } = req.body;

    // Validate required fields
    if (!placeId) {
      return res.status(400).json({
        success: false,
        message: 'Place ID is required'
      });
    }

    if (!currentLocation || !currentLocation.latitude || !currentLocation.longitude) {
      return res.status(400).json({
        success: false,
        message: 'Current location (latitude and longitude) is required'
      });
    }

    const place = await Place.findById(placeId)
      .populate('category', 'nameAr nameEn slug icon color')
      .populate('owner', 'name email phone');

    if (!place) {
      return res.status(404).json({
        success: false,
        message: 'Place not found'
      });
    }

    if (!place.isActive) {
      return res.status(400).json({
        success: false,
        message: 'This place is currently not available'
      });
    }

    // Calculate distance if place has location
    let distance = null;
    let distanceText = null;
    let estimatedTime = null;

    if (place.location && place.location.latitude && place.location.longitude) {
      distance = calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        place.location.latitude,
        place.location.longitude
      );

      // Format distance text
      if (distance < 1000) {
        distanceText = `${Math.round(distance)} meters`;
      } else {
        distanceText = `${(distance / 1000).toFixed(1)} km`;
      }

      // Estimate travel time (assuming average speed of 30 km/h in city)
      const timeInMinutes = Math.round((distance / 1000) / 30 * 60);
      if (timeInMinutes < 60) {
        estimatedTime = `${timeInMinutes} min`;
      } else {
        const hours = Math.floor(timeInMinutes / 60);
        const mins = timeInMinutes % 60;
        estimatedTime = `${hours}h ${mins}min`;
      }
    }

    return res.status(200).json({
      success: true,
      message: 'Place selected successfully',
      data: {
        place: {
          _id: place._id,
          name: place.name,
          price: place.price,
          priceRange: place.priceRange,
          category: place.category,
          address: place.address,
          phone: place.phone,
          city: place.city,
          description: place.description,
          images: place.images,
          rating: place.rating,
          ratingCount: place.ratingCount,
          workingHours: place.workingHours,
          features: place.features,
          location: place.location,
          owner: place.owner
        },
        navigation: {
          currentLocation: {
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude
          },
          destination: place.location,
          distance: distance ? Math.round(distance) : null,
          distanceText: distanceText,
          estimatedTime: estimatedTime
        }
      }
    });

  } catch (error) {
    console.error('Select place error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while selecting place',
      error: error.message
    });
  }
};

/**
 * Filter places by budget with distance from current location
 * POST /api/budget/filter-with-location
 */
exports.filterByBudgetWithLocation = async (req, res) => {
  try {
    const { budget, currentLocation, maxDistance } = req.body;

    // Validate budget
    if (!budget || isNaN(budget) || parseFloat(budget) <= 0) {
      return res.status(400).json({
        success: false,
        message: 'Please provide a valid budget value'
      });
    }

    const userBudget = parseFloat(budget);
    const hasLocation = currentLocation && currentLocation.latitude && currentLocation.longitude;

    // Find all places where price <= user's budget and is active
    const affordablePlaces = await Place.find({
      price: { $lte: userBudget, $ne: null },
      isActive: true
    })
      .populate('category')
      .select('name price category categorySlug address city description images rating ratingCount location');

    if (affordablePlaces.length === 0) {
      return res.status(200).json({
        success: true,
        message: 'No places found within your budget',
        budget: userBudget,
        data: {
          categories: [],
          totalPlaces: 0
        }
      });
    }

    // Group places by category and add distance info
    const categoriesMap = {};

    affordablePlaces.forEach(place => {
      const categoryId = place.category._id.toString();

      if (!categoriesMap[categoryId]) {
        categoriesMap[categoryId] = {
          _id: place.category._id,
          nameAr: place.category.nameAr,
          nameEn: place.category.nameEn,
          slug: place.category.slug,
          icon: place.category.icon,
          image: place.category.image,
          color: place.category.color,
          description: place.category.description,
          places: []
        };
      }

      // Calculate distance if user provided location
      let distance = null;
      let distanceText = null;

      if (hasLocation && place.location && place.location.latitude && place.location.longitude) {
        distance = calculateDistance(
          currentLocation.latitude,
          currentLocation.longitude,
          place.location.latitude,
          place.location.longitude
        );

        // Format distance
        if (distance < 1000) {
          distanceText = `${Math.round(distance)}m`;
        } else {
          distanceText = `${(distance / 1000).toFixed(1)}km`;
        }

        // Skip if exceeds max distance (if specified)
        if (maxDistance && distance > maxDistance) {
          return; // Skip this place
        }
      }

      categoriesMap[categoryId].places.push({
        _id: place._id,
        name: place.name,
        price: place.price,
        address: place.address,
        city: place.city,
        description: place.description,
        images: place.images,
        rating: place.rating,
        ratingCount: place.ratingCount,
        location: place.location,
        distance: distance ? Math.round(distance) : null,
        distanceText: distanceText
      });
    });

    // Remove empty categories and sort places by distance
    const categories = Object.values(categoriesMap)
      .filter(cat => cat.places.length > 0)
      .map(cat => {
        // Sort places by distance (nearest first)
        if (hasLocation) {
          cat.places.sort((a, b) => {
            if (a.distance === null) return 1;
            if (b.distance === null) return -1;
            return a.distance - b.distance;
          });
        }
        return cat;
      });

    const totalPlaces = categories.reduce((sum, cat) => sum + cat.places.length, 0);

    return res.status(200).json({
      success: true,
      message: `Found ${totalPlaces} places within your budget`,
      budget: userBudget,
      currentLocation: hasLocation ? currentLocation : null,
      data: {
        categories: categories,
        totalPlaces: totalPlaces,
        totalCategories: categories.length
      }
    });

  } catch (error) {
    console.error('Budget filter with location error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while filtering by budget',
      error: error.message
    });
  }
};

/**
 * Get all free places (price = 0 or null)
 * GET /api/budget/free-places
 */
exports.getFreePlaces = async (req, res) => {
  try {
    const { currentLatitude, currentLongitude, categorySlug } = req.query;
    const hasLocation = currentLatitude && currentLongitude;

    // Build query for free places
    const query = {
      $or: [
        { price: 0 },
        { price: null },
        { price: { $exists: false } }
      ],
      isActive: true
    };

    // Filter by category if provided
    if (categorySlug) {
      query.categorySlug = categorySlug;
    }

    const freePlaces = await Place.find(query)
      .populate('category')
      .select('name price category categorySlug address city description images rating ratingCount location features');

    if (freePlaces.length === 0) {
      return res.status(200).json({
        success: true,
        message: 'No free places found',
        data: {
          categories: [],
          totalPlaces: 0
        }
      });
    }

    // Group places by category and add distance if location provided
    const categoriesMap = {};

    freePlaces.forEach(place => {
      const categoryId = place.category._id.toString();

      if (!categoriesMap[categoryId]) {
        categoriesMap[categoryId] = {
          _id: place.category._id,
          nameAr: place.category.nameAr,
          nameEn: place.category.nameEn,
          slug: place.category.slug,
          icon: place.category.icon,
          image: place.category.image,
          color: place.category.color,
          places: []
        };
      }

      // Calculate distance if user provided location
      let distance = null;
      let distanceText = null;

      if (hasLocation && place.location && place.location.latitude && place.location.longitude) {
        distance = calculateDistance(
          parseFloat(currentLatitude),
          parseFloat(currentLongitude),
          place.location.latitude,
          place.location.longitude
        );

        if (distance < 1000) {
          distanceText = `${Math.round(distance)}m`;
        } else {
          distanceText = `${(distance / 1000).toFixed(1)}km`;
        }
      }

      categoriesMap[categoryId].places.push({
        _id: place._id,
        name: place.name,
        price: 0,
        isFree: true,
        address: place.address,
        city: place.city,
        description: place.description,
        images: place.images,
        rating: place.rating,
        ratingCount: place.ratingCount,
        location: place.location,
        features: place.features,
        distance: distance ? Math.round(distance) : null,
        distanceText: distanceText
      });
    });

    // Sort places by distance if location provided
    const categories = Object.values(categoriesMap).map(cat => {
      if (hasLocation) {
        cat.places.sort((a, b) => {
          if (a.distance === null) return 1;
          if (b.distance === null) return -1;
          return a.distance - b.distance;
        });
      }
      return cat;
    });

    return res.status(200).json({
      success: true,
      message: `Found ${freePlaces.length} free places`,
      data: {
        categories: categories,
        totalPlaces: freePlaces.length,
        totalCategories: categories.length
      }
    });

  } catch (error) {
    console.error('Get free places error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while fetching free places',
      error: error.message
    });
  }
};

/**
 * Get all places for map display
 * GET /api/budget/map-places
 * Returns places with locations for map markers
 */
exports.getMapPlaces = async (req, res) => {
  try {
    const {
      categorySlug,
      minPrice,
      maxPrice,
      centerLatitude,
      centerLongitude,
      radius,
      limit
    } = req.query;

    // Build query
    const query = {
      isActive: true,
      'location.latitude': { $exists: true, $ne: null },
      'location.longitude': { $exists: true, $ne: null }
    };

    // Filter by category
    if (categorySlug) {
      query.categorySlug = categorySlug;
    }

    // Filter by price range
    if (minPrice !== undefined || maxPrice !== undefined) {
      query.price = {};
      if (minPrice !== undefined) {
        query.price.$gte = parseFloat(minPrice);
      }
      if (maxPrice !== undefined) {
        query.price.$lte = parseFloat(maxPrice);
      }
    }

    let places = await Place.find(query)
      .populate('category', 'nameAr nameEn slug icon color')
      .select('name price category categorySlug address city images rating location')
      .limit(parseInt(limit) || 100);

    // Filter by radius if center location and radius provided
    if (centerLatitude && centerLongitude && radius) {
      const centerLat = parseFloat(centerLatitude);
      const centerLng = parseFloat(centerLongitude);
      const maxRadius = parseFloat(radius); // in meters

      places = places.filter(place => {
        if (place.location && place.location.latitude && place.location.longitude) {
          const distance = calculateDistance(
            centerLat,
            centerLng,
            place.location.latitude,
            place.location.longitude
          );
          return distance <= maxRadius;
        }
        return false;
      });
    }

    // Format response for map display
    const mapPlaces = places.map(place => {
      let distance = null;
      let distanceText = null;

      if (centerLatitude && centerLongitude && place.location) {
        distance = calculateDistance(
          parseFloat(centerLatitude),
          parseFloat(centerLongitude),
          place.location.latitude,
          place.location.longitude
        );

        if (distance < 1000) {
          distanceText = `${Math.round(distance)}m`;
        } else {
          distanceText = `${(distance / 1000).toFixed(1)}km`;
        }
      }

      return {
        _id: place._id,
        name: place.name,
        price: place.price,
        isFree: !place.price || place.price === 0,
        category: {
          _id: place.category._id,
          nameAr: place.category.nameAr,
          nameEn: place.category.nameEn,
          slug: place.category.slug,
          icon: place.category.icon,
          color: place.category.color
        },
        address: place.address,
        city: place.city,
        rating: place.rating,
        image: place.images && place.images.length > 0 ? place.images[0] : null,
        marker: {
          latitude: place.location.latitude,
          longitude: place.location.longitude
        },
        distance: distance ? Math.round(distance) : null,
        distanceText: distanceText
      };
    });

    // Sort by distance if center location provided
    if (centerLatitude && centerLongitude) {
      mapPlaces.sort((a, b) => {
        if (a.distance === null) return 1;
        if (b.distance === null) return -1;
        return a.distance - b.distance;
      });
    }

    return res.status(200).json({
      success: true,
      message: `Found ${mapPlaces.length} places for map`,
      data: {
        places: mapPlaces,
        totalPlaces: mapPlaces.length,
        bounds: mapPlaces.length > 0 ? {
          minLat: Math.min(...mapPlaces.map(p => p.marker.latitude)),
          maxLat: Math.max(...mapPlaces.map(p => p.marker.latitude)),
          minLng: Math.min(...mapPlaces.map(p => p.marker.longitude)),
          maxLng: Math.max(...mapPlaces.map(p => p.marker.longitude))
        } : null
      }
    });

  } catch (error) {
    console.error('Get map places error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while fetching map places',
      error: error.message
    });
  }
};

/**
 * Get nearby places for map
 * POST /api/budget/nearby-places
 */
exports.getNearbyPlaces = async (req, res) => {
  try {
    const { currentLocation, radius, categorySlug, maxPrice, limit } = req.body;

    if (!currentLocation || !currentLocation.latitude || !currentLocation.longitude) {
      return res.status(400).json({
        success: false,
        message: 'Current location (latitude and longitude) is required'
      });
    }

    const searchRadius = radius || 5000; // Default 5km
    const maxResults = limit || 50;

    // Build query
    const query = {
      isActive: true,
      'location.latitude': { $exists: true, $ne: null },
      'location.longitude': { $exists: true, $ne: null }
    };

    if (categorySlug) {
      query.categorySlug = categorySlug;
    }

    if (maxPrice !== undefined) {
      query.price = { $lte: parseFloat(maxPrice) };
    }

    const places = await Place.find(query)
      .populate('category', 'nameAr nameEn slug icon color')
      .select('name price category categorySlug address city images rating ratingCount location features');

    // Filter and sort by distance
    const nearbyPlaces = places
      .map(place => {
        const distance = calculateDistance(
          currentLocation.latitude,
          currentLocation.longitude,
          place.location.latitude,
          place.location.longitude
        );

        let distanceText;
        if (distance < 1000) {
          distanceText = `${Math.round(distance)}m`;
        } else {
          distanceText = `${(distance / 1000).toFixed(1)}km`;
        }

        // Estimate walking time (5 km/h)
        const walkingTime = Math.round((distance / 1000) / 5 * 60);
        // Estimate driving time (30 km/h in city)
        const drivingTime = Math.round((distance / 1000) / 30 * 60);

        return {
          _id: place._id,
          name: place.name,
          price: place.price,
          isFree: !place.price || place.price === 0,
          category: place.category,
          address: place.address,
          city: place.city,
          image: place.images && place.images.length > 0 ? place.images[0] : null,
          rating: place.rating,
          ratingCount: place.ratingCount,
          features: place.features,
          location: place.location,
          distance: Math.round(distance),
          distanceText: distanceText,
          estimatedTime: {
            walking: walkingTime > 0 ? `${walkingTime} min walk` : '< 1 min walk',
            driving: drivingTime > 0 ? `${drivingTime} min drive` : '< 1 min drive'
          }
        };
      })
      .filter(place => place.distance <= searchRadius)
      .sort((a, b) => a.distance - b.distance)
      .slice(0, maxResults);

    return res.status(200).json({
      success: true,
      message: `Found ${nearbyPlaces.length} nearby places`,
      searchRadius: searchRadius,
      currentLocation: currentLocation,
      data: {
        places: nearbyPlaces,
        totalPlaces: nearbyPlaces.length
      }
    });

  } catch (error) {
    console.error('Get nearby places error:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error while fetching nearby places',
      error: error.message
    });
  }
};

// Helper function to calculate distance between two coordinates (Haversine formula)
function calculateDistance(lat1, lon1, lat2, lon2) {
  const R = 6371e3; // Earth's radius in meters
  const φ1 = lat1 * Math.PI / 180;
  const φ2 = lat2 * Math.PI / 180;
  const Δφ = (lat2 - lat1) * Math.PI / 180;
  const Δλ = (lon2 - lon1) * Math.PI / 180;

  const a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
    Math.cos(φ1) * Math.cos(φ2) *
    Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return R * c; // Distance in meters
}
