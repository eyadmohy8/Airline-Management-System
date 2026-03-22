const Booking = require('../models/Booking');
const Flight = require('../models/Flight');
const Seat = require('../models/Seat');

// @desc    Create a new booking
// @route   POST /api/bookings
// @access  Private
const createBooking = async (req, res) => {
    const { flightId, seatId } = req.body;

    try {
        // Check if flight exists
        const flight = await Flight.getFlightById(flightId);
        if (!flight) {
            return res.status(404).json({ message: 'Flight not found' });
        }

        // Check if seat is available
        const seat = await Seat.getSeatByIdAndFlight(seatId, flightId);
        if (!seat) {
            return res.status(404).json({ message: 'Seat not found on this flight' });
        }
        if (seat.isBooked) {
            return res.status(400).json({ message: 'Seat is already booked' });
        }

        // Calculate price
        const priceMultiplier = seat.seatClass === 'Business' ? 2 : 1;
        const totalPrice = flight.basePrice * priceMultiplier;

        // Create booking
        const booking = await Booking.createBooking({
            user: req.user.id,
            flight: flightId,
            seat: seatId,
            totalPrice,
            paymentStatus: 'Completed',
        });

        // Update Seat and Flight availability
        await Seat.updateSeat(seatId, {
            isBooked: true,
            bookedBy: req.user.id
        });

        await Flight.updateFlight(flightId, {
            availableSeats: flight.availableSeats - 1
        });

        res.status(201).json(booking);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error creating booking' });
    }
};

// @desc    Get logged in user bookings
// @route   GET /api/bookings/mybookings
// @access  Private
const getMyBookings = async (req, res) => {
    try {
        const bookings = await Booking.getBookingsByUser(req.user.id);

        // Populate flight and seat data manually since Firestore isn't relational
        const populatedBookings = await Promise.all(bookings.map(async (b) => {
            const flight = await Flight.getFlightById(b.flight);
            const seat = await Seat.getSeatByIdAndFlight(b.seat, b.flight);

            return {
                ...b,
                flight: {
                    flightNumber: flight ? flight.flightNumber : null,
                    origin: flight ? flight.origin : null,
                    destination: flight ? flight.destination : null,
                    departureTime: flight ? flight.departureTime : null
                },
                seat: {
                    seatNumber: seat ? seat.seatNumber : null,
                    seatClass: seat ? seat.seatClass : null
                }
            };
        }));

        res.json(populatedBookings);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error fetching bookings' });
    }
};

module.exports = {
    createBooking,
    getMyBookings,
};
