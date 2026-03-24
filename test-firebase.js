const { db } = require('./backend/config/firebase.js');

async function testConnection() {
    try {
        console.log("Attempting to connect to Firebase Firestore Database...");
        
        // Try writing a simple test document
        const devRef = db.collection('test_connection').doc('test_doc');
        await devRef.set({
            timestamp: Date.now(),
            message: 'Firestore Connection successful!'
        });
        
        console.log("Write successful.");
        
        // Read back the value
        const snapshot = await devRef.get();
        console.log("Read successful. Value:", snapshot.data());

        // Cleanup
        await devRef.delete();
        console.log("Cleanup successful. Firestore DB connection is fully working.");
        process.exit(0);
    } catch (error) {
        console.error("Firestore Connection Error:", error);
        process.exit(1);
    }
}

testConnection();
