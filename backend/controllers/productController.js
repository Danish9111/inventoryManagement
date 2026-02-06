const Product = require("../models/Product");

/**
 * @desc    Get all products with filtering, search, and pagination
 * @route   GET /api/products
 * @access  Public
 */
const getProducts = async (req, res) => {
    try {
        const {
            category,
            brand,
            search,
            featured,
            minPrice,
            maxPrice,
            page = 1,
            limit = 50,
            sort = "-createdAt",
        } = req.query;

        // Build filter object
        const filter = {};

        if (category && category !== "All") {
            filter.category = category;
        }

        if (brand) {
            filter.brand = brand;
        }

        if (featured === "true") {
            filter.isFeatured = true;
        }

        if (minPrice || maxPrice) {
            filter.price = {};
            if (minPrice) filter.price.$gte = Number(minPrice);
            if (maxPrice) filter.price.$lte = Number(maxPrice);
        }

        // Search by name, category, or barcode
        if (search) {
            filter.$or = [
                { name: { $regex: search, $options: "i" } },
                { category: { $regex: search, $options: "i" } },
                { barcode: { $regex: search, $options: "i" } },
                { sku: { $regex: search, $options: "i" } },
            ];
        }

        // Pagination
        const skip = (Number(page) - 1) * Number(limit);

        // Execute query
        const products = await Product.find(filter)
            .sort(sort)
            .skip(skip)
            .limit(Number(limit))
            .lean();

        const total = await Product.countDocuments(filter);

        res.json({
            success: true,
            count: products.length,
            total,
            page: Number(page),
            pages: Math.ceil(total / Number(limit)),
            data: products,
        });
    } catch (error) {
        console.error("Error fetching products:", error);
        res.status(500).json({ message: error.message });
    }
};

/**
 * @desc    Get single product by ID
 * @route   GET /api/products/:id
 * @access  Public
 */
const getProductById = async (req, res) => {
    try {
        const product = await Product.findById(req.params.id).lean();

        if (!product) {
            return res.status(404).json({ message: "Product not found" });
        }

        res.json({
            success: true,
            data: product,
        });
    } catch (error) {
        // Handle invalid ObjectId
        if (error.kind === "ObjectId") {
            return res.status(404).json({ message: "Product not found" });
        }
        res.status(500).json({ message: error.message });
    }
};

/**
 * @desc    Get product by barcode
 * @route   GET /api/products/barcode/:barcode
 * @access  Public
 */
const getProductByBarcode = async (req, res) => {
    try {
        const product = await Product.findOne({
            barcode: req.params.barcode,
        }).lean();

        if (!product) {
            return res.status(404).json({ message: "Product not found" });
        }

        res.json({
            success: true,
            data: product,
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

/**
 * @desc    Create new product
 * @route   POST /api/products
 * @access  Private/Admin
 */
const createProduct = async (req, res) => {
    try {
        const {
            name,
            slug,
            sku,
            sellingType,
            category,
            subCategory,
            brand,
            unit,
            quantity,
            price,
            salePrice,
            quantityAlert,
            description,
            images,
            barcode,
            isFeatured,
            hasWarranty,
            expiryDate,
        } = req.body;

        // Validate required fields
        if (!name || !sku || !category || !price) {
            return res.status(400).json({
                message: "Name, SKU, category, and price are required",
            });
        }

        // Check for duplicate SKU
        const existingSku = await Product.findOne({ sku: sku.toUpperCase() });
        if (existingSku) {
            return res.status(400).json({ message: "SKU already exists" });
        }

        // Check for duplicate barcode if provided
        if (barcode) {
            const existingBarcode = await Product.findOne({ barcode });
            if (existingBarcode) {
                return res.status(400).json({ message: "Barcode already exists" });
            }
        }

        // Generate slug from name if not provided
        const productSlug =
            slug ||
            name
                .toLowerCase()
                .replace(/[^a-z0-9]+/g, "-")
                .replace(/(^-|-$)/g, "");

        // Check for duplicate slug
        let finalSlug = productSlug;
        const existingSlug = await Product.findOne({ slug: productSlug });
        if (existingSlug) {
            finalSlug = `${productSlug}-${Date.now()}`;
        }

        const product = await Product.create({
            name,
            slug: finalSlug,
            sku: sku.toUpperCase(),
            sellingType: sellingType || "Both",
            category,
            subCategory: subCategory || "",
            brand: brand || "",
            unit: unit || "Pc",
            quantity: quantity || 0,
            price,
            salePrice: salePrice || null,
            quantityAlert: quantityAlert || 10,
            description: description || "",
            images: images || [],
            barcode: barcode || null,
            isFeatured: isFeatured || false,
            hasWarranty: hasWarranty || false,
            expiryDate: expiryDate || null,
            createdBy: req.user._id,
        });

        res.status(201).json({
            success: true,
            message: "Product created successfully",
            data: product,
        });
    } catch (error) {
        console.error("Error creating product:", error);

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
 * @desc    Update product
 * @route   PUT /api/products/:id
 * @access  Private/Admin
 */
const updateProduct = async (req, res) => {
    try {
        const product = await Product.findById(req.params.id);

        if (!product) {
            return res.status(404).json({ message: "Product not found" });
        }

        // Check for duplicate SKU if being updated
        if (req.body.sku && req.body.sku.toUpperCase() !== product.sku) {
            const existingSku = await Product.findOne({
                sku: req.body.sku.toUpperCase(),
            });
            if (existingSku) {
                return res.status(400).json({ message: "SKU already exists" });
            }
        }

        // Check for duplicate barcode if being updated
        if (req.body.barcode && req.body.barcode !== product.barcode) {
            const existingBarcode = await Product.findOne({
                barcode: req.body.barcode,
            });
            if (existingBarcode) {
                return res.status(400).json({ message: "Barcode already exists" });
            }
        }

        // Update fields
        const updatableFields = [
            "name",
            "slug",
            "sku",
            "sellingType",
            "category",
            "subCategory",
            "brand",
            "unit",
            "quantity",
            "price",
            "salePrice",
            "quantityAlert",
            "description",
            "images",
            "barcode",
            "isFeatured",
            "hasWarranty",
            "expiryDate",
        ];

        updatableFields.forEach((field) => {
            if (req.body[field] !== undefined) {
                product[field] = req.body[field];
            }
        });

        // Uppercase SKU
        if (req.body.sku) {
            product.sku = req.body.sku.toUpperCase();
        }

        const updatedProduct = await product.save();

        res.json({
            success: true,
            message: "Product updated successfully",
            data: updatedProduct,
        });
    } catch (error) {
        if (error.kind === "ObjectId") {
            return res.status(404).json({ message: "Product not found" });
        }
        res.status(500).json({ message: error.message });
    }
};

/**
 * @desc    Delete product
 * @route   DELETE /api/products/:id
 * @access  Private/Admin
 */
const deleteProduct = async (req, res) => {
    try {
        // Validate ObjectId format
        if (!req.params.id.match(/^[0-9a-fA-F]{24}$/)) {
            return res.status(400).json({ message: "Invalid product ID format" });
        }

        const product = await Product.findById(req.params.id);

        if (!product) {
            return res.status(404).json({ message: "Product not found" });
        }

        await Product.deleteOne({ _id: req.params.id });

        res.json({
            success: true,
            message: "Product deleted successfully",
        });
    } catch (error) {
        console.error("Delete error:", error);
        if (error.name === "CastError") {
            return res.status(400).json({ message: "Invalid product ID" });
        }
        res.status(500).json({ message: error.message });
    }
};

/**
 * @desc    Get unique categories
 * @route   GET /api/products/categories
 * @access  Public
 */
const getCategories = async (req, res) => {
    try {
        const categories = await Product.distinct("category");
        res.json({
            success: true,
            data: ["All", ...categories],
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = {
    getProducts,
    getProductById,
    getProductByBarcode,
    createProduct,
    updateProduct,
    deleteProduct,
    getCategories,
};
