const express = require('express');
const router = express.Router();
const isAdmin = require('../middleware/admin');

// Apply admin check to all routes in this file
router.use(isAdmin);

/**
 * @route   POST /api/flights
 * @desc    Add a new flight
 * @access  Admin
 */
router.post('/', (req, res) => {
  // Logic to add flight to Firestore
  res.json({ message: 'Flight added successfully (Administrative Action)' });
});

/**
 * @route   PUT /api/flights/:id
 * @desc    Update flight details
 * @access  Admin
 */
router.put('/:id', (req, res) => {
  // Logic to update flight in Firestore
  res.json({ message: `Flight ${req.params.id} updated successfully` });
});

module.exports = router;
