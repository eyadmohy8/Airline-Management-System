const { db } = require('../config/firebase');

const usersCollection = db.collection('users');

const createUser = async (uid, userData) => {
    userData.createdAt = new Date().toISOString();
    
    // Use the Firebase Auth UID as the Firestore document ID to keep them in sync
    await usersCollection.doc(uid).set(userData);
    
    const userDoc = await usersCollection.doc(uid).get();
    return { id: userDoc.id, ...userDoc.data() };
};

const getUserByEmail = async (email) => {
    const snapshot = await usersCollection.where('email', '==', email).limit(1).get();
    if (snapshot.empty) return null;
    const doc = snapshot.docs[0];
    return { id: doc.id, ...doc.data() };
};

const getUserById = async (uid) => {
    const doc = await usersCollection.doc(uid).get();
    if (!doc.exists) return null;
    return { id: doc.id, ...doc.data() };
};

module.exports = {
    createUser,
    getUserByEmail,
    getUserById
};
