// middleware/validationMiddleware.js

// ✅ Validation Middleware للـ Registration
const validateOwnerRegistration = (req, res, next) => {
  const { name, email, password, placeName, placeType } = req.body;
  const errors = [];

  // Check required fields
  if (!name || name.trim().length < 2) {
    errors.push("Name must be at least 2 characters");
  }

  if (!email) {
    errors.push("Email is required");
  } else {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      errors.push("Invalid email format");
    }
  }

  if (!password) {
    errors.push("Password is required");
  } else {
    // Password strength
    if (password.length < 8) {
      errors.push("Password must be at least 8 characters");
    }
    if (!/[A-Z]/.test(password)) {
      errors.push("Password must contain at least one uppercase letter");
    }
    if (!/[a-z]/.test(password)) {
      errors.push("Password must contain at least one lowercase letter");
    }
    if (!/[0-9]/.test(password)) {
      errors.push("Password must contain at least one number");
    }
  }

  if (!placeName || placeName.trim().length < 2) {
    errors.push("Place name is required (min 2 characters)");
  }

  if (!placeType) {
    errors.push("Place type is required");
  } else if (!["cafe", "restaurant", "hotel", "gym", "other"].includes(placeType)) {
    errors.push("Invalid place type");
  }

  // If there are errors, return them
  if (errors.length > 0) {
    return res.status(400).json({ 
      message: "Validation failed", 
      errors 
    });
  }

  next();
};

// ✅ Rate Limiting Middleware
const rateLimit = {};

const rateLimiter = (maxRequests = 5, windowMs = 60000) => {
  return (req, res, next) => {
    const ip = req.ip || req.connection.remoteAddress;
    const now = Date.now();

    if (!rateLimit[ip]) {
      rateLimit[ip] = { count: 1, resetTime: now + windowMs };
      return next();
    }

    if (now > rateLimit[ip].resetTime) {
      rateLimit[ip] = { count: 1, resetTime: now + windowMs };
      return next();
    }

    if (rateLimit[ip].count >= maxRequests) {
      return res.status(429).json({ 
        message: "Too many requests. Please try again later." 
      });
    }

    rateLimit[ip].count++;
    next();
  };
};

module.exports = {
  validateOwnerRegistration,
  rateLimiter
};