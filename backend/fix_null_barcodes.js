require('dotenv').config();
const mongoose = require('mongoose');

async function fixNullBarcodes() {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('Connected to MongoDB');

        // CRITICAL: Remove the barcode field from all products where it's null
        // This is required because sparse index only ignores ABSENT fields, not null values
        const result = await mongoose.connection.db.collection('products').updateMany(
            { barcode: null },
            { $unset: { barcode: "" } }
        );

        console.log(`Removed barcode field from ${result.modifiedCount} products`);

        // Verify - count products with barcode field
        const withBarcode = await mongoose.connection.db.collection('products').countDocuments({
            barcode: { $exists: true }
        });
        const withoutBarcode = await mongoose.connection.db.collection('products').countDocuments({
            barcode: { $exists: false }
        });

        console.log(`Products with barcode: ${withBarcode}`);
        console.log(`Products without barcode field: ${withoutBarcode}`);

        await mongoose.disconnect();
        console.log('Done! Now you can add products without barcode.');
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

fixNullBarcodes();
