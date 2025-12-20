/**
 * Date and Time Helper Utilities
 * Common date formatting and manipulation functions
 */

// =============================
//     Format Date (Arabic/English)
// =============================
const formatDate = (date, locale = 'ar-EG') => {
  if (!date) return null;
  const dateObj = date instanceof Date ? date : new Date(date);
  
  return new Intl.DateTimeFormat(locale, {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  }).format(dateObj);
};

// =============================
//     Format Date Time
// =============================
const formatDateTime = (date, locale = 'ar-EG') => {
  if (!date) return null;
  const dateObj = date instanceof Date ? date : new Date(date);
  
  return new Intl.DateTimeFormat(locale, {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  }).format(dateObj);
};

// =============================
//     Format Time Only
// =============================
const formatTime = (date, locale = 'ar-EG') => {
  if (!date) return null;
  const dateObj = date instanceof Date ? date : new Date(date);
  
  return new Intl.DateTimeFormat(locale, {
    hour: '2-digit',
    minute: '2-digit'
  }).format(dateObj);
};

// =============================
//     Relative Time (e.g., "2 hours ago")
// =============================
const getRelativeTime = (date) => {
  if (!date) return null;
  
  const dateObj = date instanceof Date ? date : new Date(date);
  const now = new Date();
  const diffInSeconds = Math.floor((now - dateObj) / 1000);
  
  if (diffInSeconds < 60) {
    return 'الآن'; // Just now
  }
  
  const diffInMinutes = Math.floor(diffInSeconds / 60);
  if (diffInMinutes < 60) {
    return `منذ ${diffInMinutes} دقيقة`; // X minutes ago
  }
  
  const diffInHours = Math.floor(diffInMinutes / 60);
  if (diffInHours < 24) {
    return `منذ ${diffInHours} ساعة`; // X hours ago
  }
  
  const diffInDays = Math.floor(diffInHours / 24);
  if (diffInDays < 7) {
    return `منذ ${diffInDays} يوم`; // X days ago
  }
  
  const diffInWeeks = Math.floor(diffInDays / 7);
  if (diffInWeeks < 4) {
    return `منذ ${diffInWeeks} أسبوع`; // X weeks ago
  }
  
  return formatDate(dateObj);
};

// =============================
//     Check if Date is Today
// =============================
const isToday = (date) => {
  if (!date) return false;
  const dateObj = date instanceof Date ? date : new Date(date);
  const today = new Date();
  
  return dateObj.getDate() === today.getDate() &&
         dateObj.getMonth() === today.getMonth() &&
         dateObj.getFullYear() === today.getFullYear();
};

// =============================
//     Check if Date is Yesterday
// =============================
const isYesterday = (date) => {
  if (!date) return false;
  const dateObj = date instanceof Date ? date : new Date(date);
  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  
  return dateObj.getDate() === yesterday.getDate() &&
         dateObj.getMonth() === yesterday.getMonth() &&
         dateObj.getFullYear() === yesterday.getFullYear();
};

// =============================
//     ISO String
// =============================
const toISOString = (date) => {
  if (!date) return null;
  const dateObj = date instanceof Date ? date : new Date(date);
  return dateObj.toISOString();
};

module.exports = {
  formatDate,
  formatDateTime,
  formatTime,
  getRelativeTime,
  isToday,
  isYesterday,
  toISOString
};

