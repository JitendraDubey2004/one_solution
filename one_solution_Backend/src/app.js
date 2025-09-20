// File: src/app.js

const express = require('express');
const cors = require('cors');
const apiRoutes = require('./routes/api');

const app = express();

// Middleware
app.use(express.json());
app.use(cors());

// Main API routes
app.use('/api', apiRoutes);

// A simple root endpoint to confirm the server is running
app.get('/', (req, res) => {
  res.send('Backend server is running!');
});

module.exports = app;
