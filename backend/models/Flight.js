const { db } = require('../config/firebase');

const flightsCollection = db.collection('flights');

const createFlight = async (flightData) => {
    flightData.createdAt = new Date().toISOString();

    const flightRef = await flightsCollection.add(flightData);
    const flightDoc = await flightRef.get();
    return { id: flightDoc.id, ...flightDoc.data() };
};

const getAllFlights = async () => {
    const snapshot = await flightsCollection.get();
    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
};

const getFlightById = async (id) => {
    const doc = await flightsCollection.doc(id).get();
    if (!doc.exists) return null;
    return { id: doc.id, ...doc.data() };
};

const updateFlight = async (id, updateData) => {
    await flightsCollection.doc(id).update(updateData);
};

module.exports = {
    createFlight,
    getAllFlights,
    getFlightById,
    updateFlight
};
