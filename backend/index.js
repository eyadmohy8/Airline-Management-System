require('dotenv').config();
const express = require('express');
const admin = require('firebase-admin');
const helmet = require('helmet');
const cors = require('cors');
const morgan = require('morgan');

const verifyToken = require('./middleware/auth');
const flightRoutes = require('./routes/flights');
const transactionRoutes = require('./routes/transactions');

const app = express();

// 1. Basic Security & Logging
app.use(helmet()); // Sets various HTTP headers for security
app.use(cors());   // Enables CORS
app.use(morgan('dev')); // Logging
app.use(express.json()); // Body parser

// 2. Initialize Firebase Admin (Using placeholder logic if key is missing)
try {
  const serviceAccount = require(process.env.FIREBASE_SERVICE_ACCOUNT_PATH || './serviceAccountKey.json');
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
  console.log('Firebase Admin initialized successfully');
} catch (error) {
  console.warn('Firebase Admin NOT initialized. Authorization middleware will fail until serviceAccountKey.json is provided.');
}

// 3. Health Check
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', message: 'Secure Backend is running' });
});

// 4. Secure Routes (Apply verifyToken to all API routes)
app.use('/api', verifyToken);
app.use('/api/flights', flightRoutes);
app.use('/api/transactions', transactionRoutes);

// 5. Error Handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal Server Error' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`[SECURE BACKEND] Server listening on port ${PORT}`);
});
