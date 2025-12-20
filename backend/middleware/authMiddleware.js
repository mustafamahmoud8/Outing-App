const jwt = require('jsonwebtoken');
const User = require('../models/User');

const protect = async (req, res, next) => {
  let token;

  // التحقق من وجود الـ token في Header
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      token = req.headers.authorization.split(' ')[1];

      // فك التشفير والتحقق من صحة الـ token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // جلب بيانات المستخدم من DB وحفظها في req.user
      req.user = await User.findById(decoded.id).select('-__v'); 
      next();
    } catch (error) {
      console.error(error);
      return res.status(401).json({ message: 'Not authorized, token failed' });
    }
  } else {
    return res.status(401).json({ message: 'Not authorized, no token' });
  }
};

module.exports = { protect };
