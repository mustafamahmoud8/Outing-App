/**
 * Application Constants
 * All constant values used across the application
 */

// =============================
//     Chat Types
// =============================
const CHAT_TYPES = {
  NEW: 'new',                    // دردشة جديدة
  TECHNICAL_SUPPORT: 'technical_support', // الدعم الفني
  PRIVATE: 'private'            // دردشة خاصة
};

// =============================
//     Message Types
// =============================
const MESSAGE_TYPES = {
  TEXT: 'text',
  IMAGE: 'image',
  FILE: 'file',
  LOCATION: 'location'
};

// =============================
//     Message Status
// =============================
const MESSAGE_STATUS = {
  SENT: 'sent',
  DELIVERED: 'delivered',
  READ: 'read'
};

// =============================
//     User Roles
// =============================
const USER_ROLES = {
  USER: 'user',
  OWNER: 'owner',
  ADMIN: 'admin'
};

// =============================
//     Providers
// =============================
const PROVIDERS = {
  GOOGLE: 'google',
  FACEBOOK: 'facebook',
  PHONE: 'phone',
  EMAIL: 'email'
};

// =============================
//     Place Types
// =============================
const PLACE_TYPES = {
  CAFE: 'cafe',
  RESTAURANT: 'restaurant',
  HOTEL: 'hotel',
  GYM: 'gym',
  OTHER: 'other'
};

// =============================
//     HTTP Status Codes
// =============================
const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  NO_CONTENT: 204,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  TOO_MANY_REQUESTS: 429,
  SERVER_ERROR: 500
};

// =============================
//     Pagination Defaults
// =============================
const PAGINATION = {
  DEFAULT_PAGE: 1,
  DEFAULT_LIMIT: 10,
  MAX_LIMIT: 100
};

// =============================
//     OTP Configuration
// =============================
const OTP_CONFIG = {
  LENGTH: 4,
  EXPIRY_MINUTES: 5,
  MAX_ATTEMPTS: 3,
  RATE_LIMIT_SECONDS: 60
};

// =============================
//     JWT Configuration
// =============================
const JWT_CONFIG = {
  EXPIRES_IN: '7d',
  REFRESH_EXPIRES_IN: '30d'
};

// =============================
//     File Upload Limits
// =============================
const FILE_LIMITS = {
  MAX_SIZE: 10 * 1024 * 1024, // 10MB
  ALLOWED_IMAGE_TYPES: ['image/jpeg', 'image/png', 'image/gif', 'image/webp'],
  ALLOWED_FILE_TYPES: ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
};

module.exports = {
  CHAT_TYPES,
  MESSAGE_TYPES,
  MESSAGE_STATUS,
  USER_ROLES,
  PROVIDERS,
  PLACE_TYPES,
  HTTP_STATUS,
  PAGINATION,
  OTP_CONFIG,
  JWT_CONFIG,
  FILE_LIMITS
};

