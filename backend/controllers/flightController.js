const Flight = require('../models/Flight');
const Seat = require('../models/Seat');

// @desc    Create a new flight (Admin only)
// @route   POST /api/flights
// @access  Private/Admin
const createFlight = async (req, res) => {
    const { flightNumber, origin, destination, departureTime, arrivalTime, totalSeats, basePrice } = req.body;

    try {
        const flight = await Flight.createFlight({
            flightNumber,
            origin,
            destination,
            departureTime,
            arrivalTime,
            totalSeats,
            availableSeats: totalSeats,
            basePrice,
        });

        // Automatically create seats for this flight
        const seatsToCreate = [];
        for (let i = 1; i <= totalSeats; i++) {
            const isBusiness = i <= Math.ceil(totalSeats * 0.1);
            seatsToCreate.push({
                flight: flight.id, // Reference to flight document ID
                seatNumber: `${Math.ceil(i / 6)}${String.fromCharCode(65 + ((i - 1) % 6))}`,
                seatClass: isBusiness ? 'Business' : 'Economy',
                isBooked: false,
                bookedBy: null
            });
        }
        await Seat.createSeatsBatch(seatsToCreate);

        res.status(201).json(flight);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error creating flight' });
    }
};

// @desc    Fetch all flights
// @route   GET /api/flights
// @access  Public
const getFlights = async (req, res) => {
    try {
        const flights = await Flight.getAllFlights();
        res.json(flights);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error fetching flights' });
    }
};

// @desc    Fetch single flight by ID
// @route   GET /api/flights/:id
// @access  Public
const getFlightById = async (req, res) => {
    try {
        const flight = await Flight.getFlightById(req.params.id);
        if (flight) {
            res.json(flight);
        } else {
            res.status(404).json({ message: 'Flight not found' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error fetching flight' });
    }
};

// @desc    Fetch seats for a specific flight
// @route   GET /api/flights/:id/seats
// @access  Public
const getFlightSeats = async (req, res) => {
    try {
        const seats = await Seat.getSeatsByFlightId(req.params.id);
        res.json(seats);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error fetching seats' });
    }
};

module.exports = {
    createFlight,
    getFlights,
    getFlightById,
    getFlightSeats,
};
