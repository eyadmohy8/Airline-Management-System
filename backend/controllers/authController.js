const { createUser, getUserByEmail, getUserById } = require('../models/User');
const { admin } = require('../config/firebase');

// @desc    Register a new user
// @route   POST /api/auth/register
// @access  Public
const registerUser = async (req, res) => {
    const { name, email, password, role } = req.body;

    try {
        // 1. Create user in Firebase Authentication
        let userRecord;
        try {
            userRecord = await admin.auth().createUser({
                email: email.toLowerCase(),
                password: password,
                displayName: name,
            });
        } catch (firebaseError) {
            return res.status(400).json({ message: firebaseError.message });
        }

        // 2. Add custom user data to Firestore with matching UID
        const user = await createUser(userRecord.uid, {
            name,
            email: email.toLowerCase(),
            role: role || 'passenger',
        });

        res.status(201).json({
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role,
            message: 'User registered successfully. Please authenticate via the Firebase Client SDK to login.'
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error during registration' });
    }
};

// @desc    Auth user & sync with Firestore
// @route   POST /api/auth/login
// @access  Public
const loginUser = async (req, res) => {
    // We expect the client to authenticate with Firebase directly, then send us their token
    const { token } = req.body;
    
    if (!token) {
        return res.status(400).json({ message: 'No token provided. Please authenticate via Firebase Client SDK and send the token.' });
    }

    try {
        const decodedToken = await admin.auth().verifyIdToken(token);
        const uid = decodedToken.uid;
        
        // Ensure user exists in our Firestore DB
        let user = await getUserById(uid);
        
        if (!user) {
            user = await createUser(uid, {
                name: decodedToken.name || decodedToken.email.split('@')[0],
                email: decodedToken.email,
                role: 'passenger'
            });
        }

        res.json({
            ...user,
            message: 'Successfully authenticated and synced'
        });
    } catch (error) {
        console.error(error);
        res.status(401).json({ message: 'Invalid token or login failed' });
    }
};

// @desc    Get user profile
// @route   GET /api/auth/profile
// @access  Private
const getUserProfile = async (req, res) => {
    try {
        if (req.user) {
            res.json(req.user);
        } else {
            res.status(404).json({ message: 'User not found' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error fetching profile' });
    }
};

module.exports = {
    registerUser,
    loginUser,
    getUserProfile,
};
