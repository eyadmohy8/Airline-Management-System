const { db } = require('../config/firebase');

const seatsCollection = db.collection('seats');

const createSeatsBatch = async (seatsArray) => {
    const batch = db.batch();

    seatsArray.forEach(seat => {
        const seatRef = seatsCollection.doc(); // Auto-generate ID
        seat.createdAt = new Date().toISOString();
        batch.set(seatRef, seat);
    });

    await batch.commit();
};

const getSeatsByFlightId = async (flightId) => {
    const snapshot = await seatsCollection.where('flight', '==', flightId).get();
    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
};

const getSeatByIdAndFlight = async (seatId, flightId) => {
    const doc = await seatsCollection.doc(seatId).get();
    if (!doc.exists || doc.data().flight !== flightId) return null;
    return { id: doc.id, ...doc.data() };
};

const updateSeat = async (id, updateData) => {
    await seatsCollection.doc(id).update(updateData);
};

module.exports = {
    createSeatsBatch,
    getSeatsByFlightId,
    getSeatByIdAndFlight,
    updateSeat
};
