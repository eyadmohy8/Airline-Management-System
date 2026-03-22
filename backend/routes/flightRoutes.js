const express = require('express');
const router = express.Router();
const {
    createFlight,
    getFlights,
    getFlightById,
    getFlightSeats,
} = require('../controllers/flightController');
const { protect, admin } = require('../middleware/authMiddleware');

router.route('/')
    .get(getFlights)
    .post(protect, admin, createFlight);

router.route('/:id')
    .get(getFlightById);

router.route('/:id/seats')
    .get(getFlightSeats);

module.exports = router;
