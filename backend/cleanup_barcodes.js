require('dotenv').config();
const mongoose = require('mongoose');

async function cleanupBarcodes() {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('Connected to MongoDB');

        // Find products with empty string barcodes
        const result = await mongoose.connection.db.collection('products').updateMany(
            { barcode: '' },
            { $set: { barcode: null } }
        );

        console.log(`Updated ${result.modifiedCount} products with empty barcodes to null`);

        // Also check for any products with null/empty barcodes
        const products = await mongoose.connection.db.collection('products').find({
            $or: [{ barcode: '' }, { barcode: null }]
        }).toArray();

        console.log(`Products with null/empty barcode: ${products.length}`);

        await mongoose.disconnect();
        console.log('Done!');
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

cleanupBarcodes();
