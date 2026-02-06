const mongoose = require("mongoose");

const productSchema = new mongoose.Schema(
    {
        // Identification
        name: {
            type: String,
            required: [true, "Product name is required"],
            trim: true,
        },
        slug: {
            type: String,
            required: true,
            unique: true,
            lowercase: true,
            trim: true,
        },
        sku: {
            type: String,
            required: [true, "SKU is required"],
            unique: true,
            uppercase: true,
            trim: true,
        },

        // Classification
        sellingType: {
            type: String,
            enum: ["Online", "POS", "Both"],
            default: "Both",
        },
        category: {
            type: String,
            required: [true, "Category is required"],
            trim: true,
        },
        subCategory: {
            type: String,
            trim: true,
            default: "",
        },
        brand: {
            type: String,
            trim: true,
            default: "",
        },
        unit: {
            type: String,
            trim: true,
            default: "Pc",
        },

        // Pricing & Stock
        quantity: {
            type: Number,
            required: true,
            default: 0,
            min: 0,
        },
        price: {
            type: Number,
            required: [true, "Price is required"],
            min: 0,
        },
        salePrice: {
            type: Number,
            min: 0,
            default: null,
        },
        quantityAlert: {
            type: Number,
            default: 10,
            min: 0,
        },

        // Description
        description: {
            type: String,
            trim: true,
            default: "",
        },

        // Images
        images: {
            type: [String],
            default: [],
        },

        // Barcode
        barcode: {
            type: String,
            unique: true,
            sparse: true, // Allows multiple null values
            trim: true,
        },

        // Flags
        isFeatured: {
            type: Boolean,
            default: false,
        },
        hasWarranty: {
            type: Boolean,
            default: false,
        },

        // Dates
        expiryDate: {
            type: Date,
            default: null,
        },

        // Audit
        createdBy: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
        },
    },
    {
        timestamps: true, // Adds createdAt and updatedAt
    }
);

// Index for search performance
productSchema.index({ name: "text", category: "text", brand: "text" });
productSchema.index({ category: 1 });

// Pre-save middleware to generate slug if not provided
productSchema.pre("save", function () {
    if (!this.slug) {
        this.slug = this.name
            .toLowerCase()
            .replace(/[^a-z0-9]+/g, "-")
            .replace(/(^-|-$)/g, "");
    }
});

module.exports = mongoose.model("Product", productSchema);
