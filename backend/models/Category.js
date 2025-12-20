const mongoose = require('mongoose');

const categorySchema = new mongoose.Schema({
  // Category name in Arabic and English
  nameAr: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  
  nameEn: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    lowercase: true
  },
  
  // Slug for URL
  slug: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    lowercase: true,
    index: true
  },
  
  // Category icon (icon name or URL)
  icon: {
    type: String,
    default: null
  },
  
  // Category image/background (URL)
  image: {
    type: String,
    default: null
  },
  
  // Category color (hex)
  color: {
    type: String,
    default: null
  },
  
  // Category description
  description: {
    type: String,
    default: null
  },
  
  // Category order/priority for display
  order: {
    type: Number,
    default: 0
  },
  
  // Is category active
  isActive: {
    type: Boolean,
    default: true
  },
  
  // Place count (calculated field - updated dynamically)
  placeCount: {
    type: Number,
    default: 0
  }
  
}, { 
  timestamps: true,
  toJSON: { 
    transform: (doc, ret) => {
      delete ret.__v;
      return ret;
    }
  }
});

// Indexes for faster queries
categorySchema.index({ slug: 1, isActive: 1 });
categorySchema.index({ order: 1, isActive: 1 });

module.exports = mongoose.model('Category', categorySchema);

