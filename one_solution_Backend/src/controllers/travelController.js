// File: src/controllers/travelController.js
// file contains the controller functions for the Travel & Stay feature and business logic for submitting new booking requests to the database

const TravelRequest = require('../models/TravelRequest');

exports.submitRequest = async (req, res) => {
  try {
    const requestData = req.body;

    // Create and save request in MongoDB
    const newTravelRequest = new TravelRequest(requestData);
    await newTravelRequest.save();

    console.log('Travel request saved:', newTravelRequest);

    res.status(201).json({
      message: 'Travel request submitted successfully.',
      requestId: newTravelRequest._id
    });
  } catch (error) {
    console.error('Error submitting travel request:', error);
    res.status(500).json({
      message: 'Failed to submit travel request.',
      error: error.message
    });
  }
};

