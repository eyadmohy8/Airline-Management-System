const Booking = require('../models/Booking');
const User = require('../models/User');
const Seat = require('../models/Seat');

// @desc    Get passenger manifest for a specific flight
// @route   GET /api/manifest/:flightId
// @access  Private/Admin
const getFlightManifest = async (req, res) => {
    const { flightId } = req.params;

    try {
        const bookings = await Booking.getBookingsByFlight(flightId);

        if (!bookings || bookings.length === 0) {
            return res.status(404).json({ message: 'No bookings found for this flight' });
        }

        const manifest = await Promise.all(bookings.map(async (b) => {
            const user = await User.getUserById(b.user);
            const seat = await Seat.getSeatByIdAndFlight(b.seat, b.flight);

            return {
                passengerName: user ? user.name : 'Unknown User',
                passengerEmail: user ? user.email : 'Unknown Email',
                seatNumber: seat ? seat.seatNumber : 'Unknown Seat',
                seatClass: seat ? seat.seatClass : 'Unknown Class',
                bookingStatus: b.paymentStatus
            };
        }));

        res.json(manifest);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error fetching manifest' });
    }
};

module.exports = {
    getFlightManifest,
};
