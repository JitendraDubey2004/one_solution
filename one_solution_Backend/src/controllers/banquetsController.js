// File: src/controllers/banquetsController.js
// file contains the controller functions for the Banquets & Venues feature and business logic for submitting new venue requests to the database

const Request = require('../models/Request');

exports.submitRequest = async (req, res) => {
  try {
    const requestData = req.body;
    const newRequest = new Request(requestData);
    await newRequest.save();
    
    console.log('Received new venue request and saved to database:', newRequest);
    
    res.status(201).json({
      message: "Venue request submitted successfully.",
      requestId: newRequest._id,
    });
  } catch (error) {
    console.error('Error saving request:', error);
    res.status(500).json({ message: "Failed to submit request.", error: error.message });
  }
};