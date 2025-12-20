/**
 * Validation Utilities
 * Common validation functions for the project
 */

// =============================
//     Email Validation
// =============================
const isValidEmail = (email) => {
  if (!email) return false;
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

// =============================
//     Phone Validation (Egyptian)
// =============================
const isValidPhone = (phone) => {
  if (!phone) return false;
  // Egyptian phone numbers: +2010, 010, 011, 012, 015
  const phoneRegex = /^(\+2)?01[0125]\d{8}$/;
  return phoneRegex.test(phone);
};

// =============================
//     Password Validation
// =============================
const isValidPassword = (password, minLength = 8) => {
  if (!password) return false;
  return password.length >= minLength;
};

// =============================
//     MongoDB ObjectId Validation
// =============================
const isValidObjectId = (id) => {
  if (!id) return false;
  // MongoDB ObjectId is 24 hex characters
  const objectIdRegex = /^[0-9a-fA-F]{24}$/;
  return objectIdRegex.test(id.toString());
};

// =============================
//     URL Validation
// =============================
const isValidUrl = (url) => {
  if (!url) return false;
  try {
    new URL(url);
    return true;
  } catch {
    return false;
  }
};

// =============================
//     Required Fields Checker
// =============================
const checkRequiredFields = (data, requiredFields) => {
  const missing = [];
  for (const field of requiredFields) {
    if (data[field] === undefined || data[field] === null || data[field] === '') {
      missing.push(field);
    }
  }
  return {
    isValid: missing.length === 0,
    missing
  };
};

// =============================
//     Pagination Validation
// =============================
const validatePagination = (page, limit, maxLimit = 100) => {
  const pageNum = parseInt(page) || 1;
  const limitNum = parseInt(limit) || 10;
  
  return {
    page: Math.max(1, pageNum),
    limit: Math.min(maxLimit, Math.max(1, limitNum)),
    skip: (Math.max(1, pageNum) - 1) * Math.min(maxLimit, Math.max(1, limitNum))
  };
};

// =============================
//     Chat Type Validation
// =============================
const isValidChatType = (type) => {
  const validTypes = ['new', 'technical_support', 'private'];
  return validTypes.includes(type);
};

// =============================
//     Message Type Validation
// =============================
const isValidMessageType = (type) => {
  const validTypes = ['text', 'image', 'file', 'location'];
  return validTypes.includes(type);
};

module.exports = {
  isValidEmail,
  isValidPhone,
  isValidPassword,
  isValidObjectId,
  isValidUrl,
  checkRequiredFields,
  validatePagination,
  isValidChatType,
  isValidMessageType
};

