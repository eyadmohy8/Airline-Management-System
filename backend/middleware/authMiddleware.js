const { admin } = require('../config/firebase');
const { getUserById } = require('../models/User');

const protect = async (req, res, next) => {
    let token;

    if (
        req.headers.authorization &&
        req.headers.authorization.startsWith('Bearer')
    ) {
        try {
            // Get token from header
            token = req.headers.authorization.split(' ')[1];

            // Verify Firebase token
            const decodedToken = await admin.auth().verifyIdToken(token);

            // Get user from our Firestore DB via their Firebase UID
            const user = await getUserById(decodedToken.uid);
            
            if (!user) {
                return res.status(401).json({ message: 'Not authorized, user data not found in database. Please register fully.' });
            }

            // Set user on request
            req.user = user;
            next();
        } catch (error) {
            console.error('Auth Middleware Error:', error);
            res.status(401).json({ message: 'Not authorized, token failed' });
        }
    }

    if (!token) {
        res.status(401).json({ message: 'Not authorized, no token' });
    }
};

const adminMiddleware = (req, res, next) => {
    if (req.user && req.user.role === 'admin') {
        next();
    } else {
        res.status(403).json({ message: 'Not authorized as an admin' });
    }
};

module.exports = { protect, admin: adminMiddleware };
