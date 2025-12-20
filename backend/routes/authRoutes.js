// routes/authRoutes.js
const express = require("express");
const router = express.Router();
const authController = require("../controllers/authController");
const { validateOwnerRegistration, rateLimiter } = require("../middleware/validationMiddleware");

// OTP Routes
router.post("/send-otp", rateLimiter(3, 60000), authController.sendOtp);
router.post("/verify-otp", rateLimiter(5, 60000), authController.verifyOtp);

// Social Login
router.post("/google", authController.loginWithGoogle);
router.post("/facebook", authController.loginWithFacebook);

// Owner Routes
router.post("/owner/register", rateLimiter(3, 300000), validateOwnerRegistration, authController.registerOwner);
router.post("/owner/login", rateLimiter(5, 60000), authController.loginOwner);

module.exports = router;