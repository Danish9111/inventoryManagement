const Customer = require("../models/Customer");

/**
 * @desc    Get all customers with filtering, search, and pagination
 * @route   GET /api/customers
 * @access  Public
 */
const getCustomers = async (req, res) => {
    try {
        const {
            search,
            page = 1,
            limit = 50,
            sort = "-createdAt",
        } = req.query;

        // Build filter object
        const filter = {};

        // Search by name, email, or phone
        if (search) {
            filter.$or = [
                { name: { $regex: search, $options: "i" } },
                { email: { $regex: search, $options: "i" } },
                { phone: { $regex: search, $options: "i" } },
            ];
        }

        // Pagination
        const skip = (Number(page) - 1) * Number(limit);

        // Execute query
        const customers = await Customer.find(filter)
            .sort(sort)
            .skip(skip)
            .limit(Number(limit))
            .lean();

        const total = await Customer.countDocuments(filter);

        res.json({
            success: true,
            count: customers.length,
            total,
            page: Number(page),
            pages: Math.ceil(total / Number(limit)),
            data: customers,
        });
    } catch (error) {
        console.error("Error fetching customers:", error);
        res.status(500).json({ message: error.message });
    }
};

/**
 * @desc    Get single customer by ID
 * @route   GET /api/customers/:id
 * @access  Public
 */
const getCustomerById = async (req, res) => {
    try {
        const customer = await Customer.findById(req.params.id).lean();

        if (!customer) {
            return res.status(404).json({ message: "Customer not found" });
        }

        res.json({
            success: true,
            data: customer,
        });
    } catch (error) {
        // Handle invalid ObjectId
        if (error.kind === "ObjectId") {
            return res.status(404).json({ message: "Customer not found" });
        }
        res.status(500).json({ message: error.message });
    }
};

/**
 * @desc    Create new customer
 * @route   POST /api/customers
 * @access  Private/Admin
 */
const createCustomer = async (req, res) => {
    try {
        // Check if body exists
        if (!req.body) {
            return res.status(400).json({
                message: "Request body is required. Make sure Content-Type is application/json",
            });
        }

        const {
            name,
            email,
            phone,
            address,
            totalSpent,
            loyaltyPoints,
            imageUrl,
        } = req.body;

        // Validate required fields
        if (!name || !email) {
            return res.status(400).json({
                message: "Name and email are required",
            });
        }

        // Check for duplicate email
        const existingCustomer = await Customer.findOne({ email: email.toLowerCase() });
        if (existingCustomer) {
            return res.status(400).json({ message: "Customer with this email already exists" });
        }

        const customer = await Customer.create({
            name,
            email: email.toLowerCase(),
            phone: phone || "",
            address: address || "",
            totalSpent: totalSpent || 0,
            loyaltyPoints: loyaltyPoints || 0,
            imageUrl: imageUrl || null,
            createdBy: req.user._id,
        });

        res.status(201).json({
            success: true,
            message: "Customer created successfully",
            data: customer,
        });
    } catch (error) {
        console.error("Error creating customer:", error);

        // Handle duplicate key errors
        if (error.code === 11000) {
            const field = Object.keys(error.keyPattern)[0];
            return res.status(400).json({
                message: `${field.charAt(0).toUpperCase() + field.slice(1)} already exists`,
            });
        }

        res.status(500).json({ message: error.message });
    }
};

/**
 * @desc    Update customer
 * @route   PUT /api/customers/:id
 * @access  Private/Admin
 */
const updateCustomer = async (req, res) => {
    try {
        const customer = await Customer.findById(req.params.id);

        if (!customer) {
            return res.status(404).json({ message: "Customer not found" });
        }

        // Check for duplicate email if being updated
        if (req.body.email && req.body.email.toLowerCase() !== customer.email) {
            const existingEmail = await Customer.findOne({
                email: req.body.email.toLowerCase(),
            });
            if (existingEmail) {
                return res.status(400).json({ message: "Email already exists" });
            }
        }

        // Update fields
        const updatableFields = [
            "name",
            "email",
            "phone",
            "address",
            "totalSpent",
            "loyaltyPoints",
            "imageUrl",
        ];

        updatableFields.forEach((field) => {
            if (req.body[field] !== undefined) {
                customer[field] = field === "email"
                    ? req.body[field].toLowerCase()
                    : req.body[field];
            }
        });


        const updatedCustomer = await customer.save();
        res.json({
            success: true,
            message: "Customer updated successfully",
            data: updatedCustomer,
        });
    } catch (error) {
        if (error.kind === "ObjectId") {
            return res.status(404).json({ message: "Customer not found" });
        }
        res.status(500).json({ message: error.message });
    }
};

/**
 * @desc    Delete customer
 * @route   DELETE /api/customers/:id
 * @access  Private/Admin
 */
const deleteCustomer = async (req, res) => {
    try {
        // Validate ObjectId format
        if (!req.params.id.match(/^[0-9a-fA-F]{24}$/)) {
            return res.status(400).json({ message: "Invalid customer ID format" });
        }

        const customer = await Customer.findById(req.params.id);

        if (!customer) {
            return res.status(404).json({ message: "Customer not found" });
        }

        await Customer.deleteOne({ _id: req.params.id });

        res.json({
            success: true,
            message: "Customer deleted successfully",
        });
    } catch (error) {
        console.error("Delete error:", error);
        if (error.name === "CastError") {
            return res.status(400).json({ message: "Invalid customer ID" });
        }
        res.status(500).json({ message: error.message });
    }
};

module.exports = {
    getCustomers,
    getCustomerById,
    createCustomer,
    updateCustomer,
    deleteCustomer,
};
