/**
 * Response Helper Utilities
 * Standardized response format for API endpoints
 */

// =============================
//     Success Responses
// =============================
const successResponse = (res, statusCode, message, data = null) => {
  const response = {
    success: true,
    message
  };
  
  if (data !== null) {
    response.data = data;
  }
  
  return res.status(statusCode).json(response);
};

// =============================
//     Error Responses
// =============================
const errorResponse = (res, statusCode, message, error = null) => {
  const response = {
    success: false,
    message
  };
  
  if (error && process.env.NODE_ENV === 'development') {
    response.error = error.message || error;
  }
  
  return res.status(statusCode).json(response);
};

// =============================
//     Common Response Functions
// =============================
module.exports = {
  // Success responses
  ok: (res, message = 'Success', data = null) => 
    successResponse(res, 200, message, data),
  
  created: (res, message = 'Created successfully', data = null) => 
    successResponse(res, 201, message, data),
  
  noContent: (res, message = 'No content') => 
    successResponse(res, 204, message),
  
  // Error responses
  badRequest: (res, message = 'Bad request', error = null) => 
    errorResponse(res, 400, message, error),
  
  unauthorized: (res, message = 'Unauthorized', error = null) => 
    errorResponse(res, 401, message, error),
  
  forbidden: (res, message = 'Forbidden', error = null) => 
    errorResponse(res, 403, message, error),
  
  notFound: (res, message = 'Not found', error = null) => 
    errorResponse(res, 404, message, error),
  
  conflict: (res, message = 'Conflict', error = null) => 
    errorResponse(res, 409, message, error),
  
  tooManyRequests: (res, message = 'Too many requests', error = null) => 
    errorResponse(res, 429, message, error),
  
  serverError: (res, message = 'Server error', error = null) => 
    errorResponse(res, 500, message, error),
  
  // Generic
  send: successResponse,
  error: errorResponse
};

