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

app.use(cors());
app.use(express.json()); // Body parser
app.use("/api/users", authRoutes);
app.use("/api/products", productRoutes);

app.get("/", (req, res) => {
    res.send("API is running...");
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});