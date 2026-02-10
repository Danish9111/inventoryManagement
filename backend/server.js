const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const connectDB = require("./config/db");
dotenv.config();
connectDB();
const app = express();
const port = process.env.PORT || 5000;
const authRoutes = require("./routes/authRoute");
const productRoutes = require("./routes/productRoutes");
const customerRoutes = require("./routes/customerRoutes");

app.use(cors());
app.use(express.json()); // Body parser
app.get("/", (req, res) => {
    res.send("API is running...");
});

app.use("/api/users", authRoutes);
app.use("/api/products", productRoutes);
app.use("/api/customers", customerRoutes);
app.use("/api/cart", require("./routes/cartRoutes"));

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});