const mongoose = require("mongoose");

const customerSchema = new mongoose.Schema(
    {
        name: {
            type: String,
            required: [true, "Customer name is required"],
            trim: true,
        },
        email: {
            type: String,
            required: [true, "Email is required"],
            unique: true,
            lowercase: true,
            trim: true,
        },
        phone: {
            type: String,
            trim: true,
            default: "",
        },
        address: {
            type: String,
            trim: true,
            default: "",
        },
        totalSpent: {
            type: Number,
            default: 0,
            min: 0,
        },
        loyaltyPoints: {
            type: Number,
            default: 0,
            min: 0,
        },
        imageUrl: {
            type: String,
            trim: true,
            default: null,
        },
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
customerSchema.index({ name: "text", email: "text", phone: "text" });
customerSchema.index({ email: 1 });

module.exports = mongoose.model("Customer", customerSchema);
