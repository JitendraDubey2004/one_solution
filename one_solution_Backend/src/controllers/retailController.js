// File: src/controllers/retailController.js
// file contains the controller functions for the Retail Stores & Shops feature and business logic for submitting new venue requests to the database

const RetailRequest = require('../models/RetailRequest');

exports.submitRequest = async (req, res) => {
  try {
    const requestData = req.body;
    
    // Create a new request using the RetailRequest model and save it
    const newRetailRequest = new RetailRequest(requestData);
    await newRetailRequest.save();

    console.log('Received new retail request and saved to database:', newRetailRequest);
    
    res.status(201).json({
      message: "Retail request submitted successfully.",
      requestId: newRetailRequest._id
    });
  } catch (error) {
    console.error('Error submitting retail request:', error);
    res.status(500).json({
      message: "Failed to submit retail request.",
      error: error.message
    });
  }
};