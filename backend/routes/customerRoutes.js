const express = require("express");
const router = express.Router();
const {
    getCustomers,
    getCustomerById,
    createCustomer,
    updateCustomer,
    deleteCustomer,
} = require("../controllers/customerController");
const { protect, admin } = require("../middleware/authMiddleware");

// Public routes
router.get("/", getCustomers);
router.get("/:id", getCustomerById);

// Protected routes (Admin only)
router.post("/", protect, admin, createCustomer);
router.put("/:id", protect, admin, updateCustomer);
router.delete("/:id", protect, admin, deleteCustomer);

module.exports = router;
