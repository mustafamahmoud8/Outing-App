const jwt = require('jsonwebtoken');

const generateToken = (user) => {
    return jwt.sign(
        { id: user._id, name: user.name, email: user.email, phone: user.phone },
        process.env.JWT_SECRET || 'secret123',
        { expiresIn: '7d' } // صلاحية 7 أيام
    );
};

module.exports = generateToken;
