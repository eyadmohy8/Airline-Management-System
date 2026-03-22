const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Optional: you can ignore undefined properties in firestore
db.settings({ ignoreUndefinedProperties: true });

module.exports = { admin, db };
