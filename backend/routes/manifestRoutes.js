const express = require('express');
const router = express.Router();
const { getFlightManifest } = require('../controllers/manifestController');
const { protect, admin } = require('../middleware/authMiddleware');

router.route('/:flightId')
    .get(protect, admin, getFlightManifest);

module.exports = router;
