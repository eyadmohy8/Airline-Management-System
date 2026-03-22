const { db } = require('../config/firebase');

const bookingsCollection = db.collection('bookings');

const createBooking = async (bookingData) => {
    bookingData.createdAt = new Date().toISOString();
    bookingData.paymentStatus = bookingData.paymentStatus || 'Pending';

    const bookingRef = await bookingsCollection.add(bookingData);
    const bookingDoc = await bookingRef.get();
    return { id: bookingDoc.id, ...bookingDoc.data() };
};

const getBookingsByUser = async (userId) => {
    const snapshot = await bookingsCollection.where('user', '==', userId).get();
    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
};

const getBookingsByFlight = async (flightId) => {
    const snapshot = await bookingsCollection.where('flight', '==', flightId).get();
    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
};

module.exports = {
    createBooking,
    getBookingsByUser,
    getBookingsByFlight
};
