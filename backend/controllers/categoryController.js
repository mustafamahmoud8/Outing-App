const Category = require('../models/Category');
const Place = require('../models/Place');

// Utils
const { ok, created, badRequest, notFound, serverError } = require('../utils/responseHelper');
const { isValidObjectId, validatePagination } = require('../utils/validators');
const { PLACE_TYPES } = require('../utils/constants');

// =============================
//     Get All Categories
// =============================
exports.getAllCategories = async (req, res) => {
  try {
    // Get all active categories
    const categories = await Category.find({ isActive: true })
      .sort({ order: 1, nameAr: 1 });

    // Get place count for each category
    const categoriesWithCount = await Promise.all(
      categories.map(async (category) => {
        const placeCount = await Place.countDocuments({
          category: category._id,
          isActive: true
        });

        // Update category place count (optional - for caching)
        if (category.placeCount !== placeCount) {
          category.placeCount = placeCount;
          await category.save();
        }

        return {
          id: category._id,
          nameAr: category.nameAr,
          nameEn: category.nameEn,
          slug: category.slug,
          icon: category.icon,
          image: category.image,
          color: category.color,
          description: category.description,
          placeCount: placeCount
        };
      })
    );

    return ok(res, 'Categories retrieved successfully', {
      categories: categoriesWithCount
    });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Get Category by Slug
// =============================
exports.getCategoryBySlug = async (req, res) => {
  try {
    const { slug } = req.params;

    const category = await Category.findOne({
      slug: slug,
      isActive: true
    });

    if (!category) {
      return notFound(res, 'Category not found');
    }

    // Get place count
    const placeCount = await Place.countDocuments({
      category: category._id,
      isActive: true
    });

    const categoryData = {
      id: category._id,
      nameAr: category.nameAr,
      nameEn: category.nameEn,
      slug: category.slug,
      icon: category.icon,
      image: category.image,
      color: category.color,
      description: category.description,
      placeCount: placeCount
    };

    return ok(res, 'Category retrieved successfully', {
      category: categoryData
    });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Get Places by Category
// =============================
exports.getPlacesByCategory = async (req, res) => {
  try {
    const { slug } = req.params;
    const { page, limit, skip } = validatePagination(req.query.page, req.query.limit, 50);
    const { city, minRating, maxPrice, sortBy } = req.query;

    // Find category
    const category = await Category.findOne({
      slug: slug,
      isActive: true
    });

    if (!category) {
      return notFound(res, 'Category not found');
    }

    // Build query
    const query = {
      category: category._id,
      isActive: true
    };

    // Filter by city
    if (city) {
      query.city = new RegExp(city, 'i');
    }

    // Filter by rating
    if (minRating) {
      query.rating = { $gte: parseFloat(minRating) };
    }

    // Filter by price range
    if (maxPrice) {
      query.priceRange = { $lte: parseInt(maxPrice) };
    }

    // Sort options
    let sort = { createdAt: -1 }; // Default: newest first
    if (sortBy === 'rating') {
      sort = { rating: -1, ratingCount: -1 };
    } else if (sortBy === 'views') {
      sort = { viewCount: -1 };
    } else if (sortBy === 'name') {
      sort = { name: 1 };
    }

    // Get places
    const places = await Place.find(query)
      .populate('owner', 'name avatar placeName placeType')
      .populate('category', 'nameAr nameEn slug icon')
      .sort(sort)
      .limit(limit)
      .skip(skip)
      .select('name address phone city location images rating ratingCount priceRange features workingHours viewCount createdAt');

    // Get total count
    const totalPlaces = await Place.countDocuments(query);

    return ok(res, 'Places retrieved successfully', {
      category: {
        id: category._id,
        nameAr: category.nameAr,
        nameEn: category.nameEn,
        slug: category.slug,
        icon: category.icon,
        image: category.image
      },
      places: places,
      pagination: {
        page,
        limit,
        totalPlaces,
        totalPages: Math.ceil(totalPlaces / limit),
        hasNextPage: page < Math.ceil(totalPlaces / limit),
        hasPreviousPage: page > 1
      }
    });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Search Places
// =============================
exports.searchPlaces = async (req, res) => {
  try {
    const { query: searchQuery } = req.query;
    const { page, limit, skip } = validatePagination(req.query.page, req.query.limit, 50);
    const { categorySlug, city, minRating } = req.query;

    // Build search query
    const query = {
      isActive: true
    };

    // Text search
    if (searchQuery) {
      query.$text = { $search: searchQuery };
    } else {
      // If no search query, return empty or use regex
      if (!categorySlug && !city) {
        return ok(res, 'Please provide search query, category, or city', {
          places: [],
          pagination: { page, limit, totalPlaces: 0, totalPages: 0 }
        });
      }
    }

    // Filter by category
    if (categorySlug) {
      const category = await Category.findOne({ slug: categorySlug, isActive: true });
      if (category) {
        query.category = category._id;
      }
    }

    // Filter by city
    if (city) {
      query.city = new RegExp(city, 'i');
    }

    // Filter by rating
    if (minRating) {
      query.rating = { $gte: parseFloat(minRating) };
    }

    // Sort options
    let sort = {};
    if (searchQuery && query.$text) {
      sort = { score: { $meta: 'textScore' } };
    } else {
      sort = { rating: -1, ratingCount: -1 };
    }

    // Get places
    const places = await Place.find(query, searchQuery && query.$text ? { score: { $meta: 'textScore' } } : {})
      .populate('owner', 'name avatar placeName placeType')
      .populate('category', 'nameAr nameEn slug icon')
      .sort(sort)
      .limit(limit)
      .skip(skip)
      .select('name address phone city location images rating ratingCount priceRange features workingHours viewCount category categorySlug createdAt');

    // Get total count
    const totalPlaces = await Place.countDocuments(query);

    return ok(res, 'Search completed successfully', {
      places: places,
      pagination: {
        page,
        limit,
        totalPlaces,
        totalPages: Math.ceil(totalPlaces / limit),
        hasNextPage: page < Math.ceil(totalPlaces / limit),
        hasPreviousPage: page > 1
      }
    });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Get Place by ID
// =============================
exports.getPlaceById = async (req, res) => {
  try {
    const { placeId } = req.params;

    if (!isValidObjectId(placeId)) {
      return badRequest(res, 'Invalid place ID');
    }

    const place = await Place.findOne({
      _id: placeId,
      isActive: true
    })
      .populate('owner', 'name avatar placeName placeType placeAddress placePhone')
      .populate('category', 'nameAr nameEn slug icon image color');

    if (!place) {
      return notFound(res, 'Place not found');
    }

    // Increment view count
    place.viewCount += 1;
    await place.save();

    return ok(res, 'Place retrieved successfully', {
      place: place
    });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

// =============================
//     Initialize Categories (One-time setup)
// =============================
exports.initializeCategories = async (req, res) => {
  try {
    // Only allow admin or first-time setup
    const categories = [
      { nameAr: 'شواطئ', nameEn: 'beaches', slug: 'beaches', icon: 'umbrella', order: 1 },
      { nameAr: 'أكوا بارك', nameEn: 'aqua_park', slug: 'aqua_park', icon: 'swim', order: 2 },
      { nameAr: 'سينمات', nameEn: 'cinemas', slug: 'cinemas', icon: 'film', order: 3 },
      { nameAr: 'مقاهي', nameEn: 'cafes', slug: 'cafes', icon: 'coffee', order: 4 },
      { nameAr: 'مطاعم', nameEn: 'restaurants', slug: 'restaurants', icon: 'restaurant', order: 5 },
      { nameAr: 'أماكن تاريخية', nameEn: 'historical', slug: 'historical', icon: 'building', order: 6 },
      { nameAr: 'حدائق', nameEn: 'gardens', slug: 'gardens', icon: 'tree', order: 7 },
      { nameAr: 'ملاهي', nameEn: 'amusement', slug: 'amusement', icon: 'ferris-wheel', order: 8 },
      { nameAr: 'مولات', nameEn: 'malls', slug: 'malls', icon: 'shopping', order: 9 },
      { nameAr: 'نوادي رياضية', nameEn: 'sports', slug: 'sports', icon: 'dumbbell', order: 10 }
    ];

    const createdCategories = [];

    for (const catData of categories) {
      const existing = await Category.findOne({ slug: catData.slug });
      if (!existing) {
        const category = await Category.create(catData);
        createdCategories.push(category);
      } else {
        createdCategories.push(existing);
      }
    }

    return ok(res, 'Categories initialized successfully', {
      categories: createdCategories
    });

  } catch (error) {
    console.error(error);
    return serverError(res, 'Server error', error);
  }
};

