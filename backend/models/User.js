const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { 
    type: String, 
    required: true,
    trim: true 
  },
  
  email: { 
    type: String, 
    unique: true,
    sparse: true, // ✅ يسمح بـ null متعددة
    lowercase: true,
    trim: true
  },
  
  phone: { 
    type: String,
    unique: true,
    sparse: true, // ✅ يسمح بـ null متعددة
    trim: true
  },
  
  password: { 
    type: String,
    select: false // ✅ مهم جداً: مش هيرجع في الـ queries العادية
  },
  
  provider: { 
    type: String, 
    required: true,
    enum: ["google", "facebook", "phone", "email"]
  },
  
  providerId: { 
    type: String 
  },
  
  avatar: { 
    type: String,
    default: null
  },

  role: {
    type: String,
    enum: ["user", "owner", "admin"],
    default: "user",
  },

  // ✅ بيانات Owner
  placeName: { 
    type: String,
    required: function() {
      return this.role === "owner";
    }
  },
  
  placeType: { 
    type: String,
    enum: ["cafe", "restaurant", "hotel", "gym", "other"],
    required: function() {
      return this.role === "owner";
    }
  },
  
  placeAddress: { 
    type: String 
  },
  
  placePhone: { 
    type: String 
  },

  // ✅ حالة الحساب
  isActive: {
    type: Boolean,
    default: true
  },

  isEmailVerified: {
    type: Boolean,
    default: false
  },

  isPhoneVerified: {
    type: Boolean,
    default: false
  },

  // ✅ آخر تسجيل دخول
  lastLogin: {
    type: Date
  }

}, { 
  timestamps: true, // createdAt, updatedAt
  toJSON: { 
    transform: (doc, ret) => {
      delete ret.password; // ✅ إخفاء password من JSON
      delete ret.__v;
      return ret;
    }
  }
});

// ✅ Indexes للأداء
userSchema.index({ email: 1 });
userSchema.index({ phone: 1 });
userSchema.index({ provider: 1, providerId: 1 });

module.exports = mongoose.model('User', userSchema);