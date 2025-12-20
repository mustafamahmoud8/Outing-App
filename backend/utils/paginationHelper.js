/**
 * Pagination Helper Utilities
 * Helper functions for pagination in API responses
 */

// =============================
//     Calculate Pagination
// =============================
const calculatePagination = (page, limit, totalItems, maxLimit = 100) => {
  const currentPage = Math.max(1, parseInt(page) || 1);
  const itemsPerPage = Math.min(maxLimit, Math.max(1, parseInt(limit) || 10));
  const totalPages = Math.ceil(totalItems / itemsPerPage);
  const skip = (currentPage - 1) * itemsPerPage;
  
  return {
    currentPage,
    itemsPerPage,
    totalItems,
    totalPages,
    skip,
    hasNextPage: currentPage < totalPages,
    hasPreviousPage: currentPage > 1
  };
};

// =============================
//     Format Paginated Response
// =============================
const formatPaginatedResponse = (data, pagination, message = 'Success') => {
  return {
    success: true,
    message,
    data,
    pagination: {
      page: pagination.currentPage,
      limit: pagination.itemsPerPage,
      totalItems: pagination.totalItems,
      totalPages: pagination.totalPages,
      hasNextPage: pagination.hasNextPage,
      hasPreviousPage: pagination.hasPreviousPage
    }
  };
};

// =============================
//     Get Skip Value
// =============================
const getSkip = (page, limit) => {
  const currentPage = Math.max(1, parseInt(page) || 1);
  const itemsPerPage = Math.max(1, parseInt(limit) || 10);
  return (currentPage - 1) * itemsPerPage;
};

module.exports = {
  calculatePagination,
  formatPaginatedResponse,
  getSkip
};

