const User = require("../models/User");
const generateToken = require("../utils/generateToken");
const { OAuth2Client } = require('google-auth-library');
const fetch = require('node-fetch');
const bcrypt = require("bcryptjs");

// ✅ استخدم Redis بدل الـ memory (أفضل)
// لكن للتطوير السريع، هنستخدم Map مع expiration
const otpStore = new Map();

// ===== 1) إرسال OTP (محسّن) =====
exports.sendOtp = async (req, res) => {
  try {
    const { phone } = req.body;

    // Validation
    if (!phone || !/^(\+2)?01[0125]\d{8}$/.test(phone)) {
      return res.status(400).json({ message: "Invalid Egyptian phone number" });
    }

    // Rate limiting: منع إرسال أكتر من OTP كل دقيقة
    const lastOtp = otpStore.get(phone);
    if (lastOtp && Date.now() - lastOtp.timestamp < 60000) {
      return res.status(429).json({
        message: "Please wait 1 minute before requesting another OTP"
      });
    }

    // توليد OTP عشوائي
    const otp = Math.floor(1000 + Math.random() * 9000);

    // حفظ مع timestamp
    otpStore.set(phone, {
      otp,
      timestamp: Date.now(),
      attempts: 0
    });

    // مسح الـ OTP بعد 5 دقائق
    setTimeout(() => otpStore.delete(phone), 5 * 60 * 1000);

    console.log(`📱 OTP for ${phone}: ${otp}`); // TODO: ربط SMS gateway

    return res.json({ message: "OTP sent successfully" });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Server error" });
  }
};

// ===== 2) التحقق من OTP (محسّن) =====
exports.verifyOtp = async (req, res) => {
  try {
    const { phone, otp } = req.body;

    if (!phone || !otp) {
      return res.status(400).json({ message: "Phone and OTP required" });
    }

    const stored = otpStore.get(phone);

    // التحقق من وجود الـ OTP
    if (!stored) {
      return res.status(400).json({ message: "OTP expired or not found" });
    }

    // منع brute force: 3 محاولات فقط
    if (stored.attempts >= 3) {
      otpStore.delete(phone);
      return res.status(429).json({ message: "Too many attempts. Request new OTP" });
    }

    // مقارنة OTP
    if (stored.otp.toString() !== otp.toString()) {
      stored.attempts++;
      return res.status(400).json({
        message: "Wrong OTP",
        attemptsLeft: 3 - stored.attempts
      });
    }

    // التحقق من انتهاء الصلاحية (5 دقائق)
    if (Date.now() - stored.timestamp > 5 * 60 * 1000) {
      otpStore.delete(phone);
      return res.status(400).json({ message: "OTP expired" });
    }

    // حذف الـ OTP بعد النجاح
    otpStore.delete(phone);

    // هل المستخدم موجود؟
    let user = await User.findOne({ phone });

    // لو جديد
    if (!user) {
      user = await User.create({
        name: phone, // سيتم تحديثه لاحقاً
        phone,
        provider: "phone",
        role: "user"
      });
    }

    // رجّع توكن
    const token = generateToken(user);

    return res.json({
      message: "OTP verified successfully",
      token,
      user: {
        id: user._id,
        name: user.name,
        phone: user.phone,
        role: user.role
      }
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Server error" });
  }
};

// ===== 3) Google Login (Firebase Integration) =====
exports.loginWithGoogle = async (req, res) => {
  try {
    const { uid, email, displayName, photoURL } = req.body;
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: "No token provided" });
    }

    const firebaseToken = authHeader.split('Bearer ')[1];

    // For development: Skip Firebase verification
    // In production, verify the Firebase token here

    // Find or create user
    let user = await User.findOne({
      $or: [
        { providerId: uid },
        { email: email }
      ]
    });

    if (!user) {
      user = await User.create({
        name: displayName || 'User',
        email: email,
        avatar: photoURL,
        provider: 'google',
        providerId: uid,
        role: 'user'
      });
    } else {
      // Update user info if exists
      user.name = displayName || user.name;
      user.avatar = photoURL || user.avatar;
      user.provider = 'google';
      user.providerId = uid;
      await user.save();
    }

    const token = generateToken(user);

    res.json({
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
        role: user.role
      }
    });
  } catch (error) {
    console.error('Google login error:', error);
    res.status(400).json({ message: 'Google login failed', error: error.message });
  }
};

// ===== 4) Facebook Login =====
exports.loginWithFacebook = async (req, res) => {
  try {
    const { accessToken } = req.body;

    if (!accessToken) {
      return res.status(400).json({ message: "Access token required" });
    }

    // Verify token with Facebook
    const response = await fetch(
      `https://graph.facebook.com/me?fields=id,name,email,picture&access_token=${accessToken}`
    );
    const data = await response.json();

    if (!data.id) {
      return res.status(400).json({ message: 'Invalid Facebook token' });
    }

    let user = await User.findOne({
      provider: 'facebook',
      providerId: data.id
    });

    if (!user) {
      user = await User.create({
        name: data.name,
        email: data.email,
        avatar: data.picture?.data?.url,
        provider: 'facebook',
        providerId: data.id,
        role: 'user'
      });
    }

    const token = generateToken(user);

    res.json({
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
        role: user.role
      }
    });
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: 'Facebook login failed' });
  }
};

// ===== 5) Owner Registration (محسّن) =====
exports.registerOwner = async (req, res) => {
  try {
    const {
      name,
      email,
      password,
      phone,
      placeName,
      placeType,
      placeAddress,
      placePhone
    } = req.body;

    // ✅ Validation شاملة
    if (!name || !email || !password || !placeName || !placeType) {
      return res.status(400).json({
        message: "All fields are required (name, email, password, placeName, placeType)"
      });
    }

    // Email format validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ message: "Invalid email format" });
    }

    // Password strength validation
    if (password.length < 8) {
      return res.status(400).json({
        message: "Password must be at least 8 characters"
      });
    }

    // التحقق من عدم تكرار الـ email أو الـ phone
    const existingUser = await User.findOne({
      $or: [
        { email },
        { phone: phone || null }
      ]
    });

    if (existingUser) {
      return res.status(409).json({
        message: "Email or phone already registered"
      });
    }

    // تشفير الـ password
    const hashed = await bcrypt.hash(password, 12);

    // إنشاء Owner
    const newOwner = await User.create({
      name,
      email,
      phone,
      password: hashed,
      provider: "email", // ✅ مهم!
      role: "owner",
      placeName,
      placeType,
      placeAddress,
      placePhone,
    });

    // إخفاء الـ password من الـ response
    const userResponse = newOwner.toObject();
    delete userResponse.password;

    res.status(201).json({
      message: "Owner registered successfully",
      token: generateToken(newOwner), // ✅ صح
      user: userResponse,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

// ===== 6) Owner Login (جديد) =====
exports.loginOwner = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: "Email and password required" });
    }

    // البحث عن الـ owner
    const owner = await User.findOne({ email, role: "owner" });

    if (!owner || !owner.password) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // التحقق من الـ password
    const isMatch = await bcrypt.compare(password, owner.password);

    if (!isMatch) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // توليد token
    const token = generateToken(owner);

    // إخفاء الـ password
    const userResponse = owner.toObject();
    delete userResponse.password;

    res.json({
      message: "Login successful",
      token,
      user: userResponse
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};