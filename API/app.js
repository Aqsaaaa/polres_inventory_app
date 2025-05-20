const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');

const userRoutes = require('./routes/userRoutes');
const barangRoutes = require('./routes/barangRoutes');
const historyRoutes = require('./routes/historyRoutes');

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Serve static files for uploaded images
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use('/users', userRoutes);
app.use('/barang', barangRoutes);
app.use('/history', historyRoutes);

// Start server
app.listen(port, () => {
  console.log(`Inventory API server running at http://localhost:${port}`);
});
