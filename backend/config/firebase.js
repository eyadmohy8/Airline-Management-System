const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: 'https://airline-9ff31-default-rtdb.firebaseio.com'
});

const db = admin.firestore();
const realtimeDb = admin.database();

// Optional: you can ignore undefined properties in firestore
db.settings({ ignoreUndefinedProperties: true });

module.exports = { admin, db, realtimeDb };
