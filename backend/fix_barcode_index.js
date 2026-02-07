require('dotenv').config();
const mongoose = require('mongoose');

async function fixBarcodeIndex() {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('Connected to MongoDB');

        // Get current indexes
        const indexes = await mongoose.connection.db.collection('products').indexes();
        console.log('Current indexes:');
        indexes.forEach(idx => console.log(JSON.stringify(idx)));

        // Drop the old barcode index if exists
        try {
            await mongoose.connection.db.collection('products').dropIndex('barcode_1');
            console.log('Dropped old barcode index');
        } catch (e) {
            console.log('No barcode_1 index to drop or error:', e.message);
        }

        // Create a proper sparse unique index
        await mongoose.connection.db.collection('products').createIndex(
            { barcode: 1 },
            { unique: true, sparse: true, name: 'barcode_1' }
        );
        console.log('Created new sparse unique barcode index');

        // Also set any empty string barcodes to null
        const updateResult = await mongoose.connection.db.collection('products').updateMany(
            { barcode: '' },
            { $unset: { barcode: 1 } }
        );
        console.log(`Unset ${updateResult.modifiedCount} empty barcode fields`);

        await mongoose.disconnect();
        console.log('Done!');
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

fixBarcodeIndex();
