// File: src/models/Request.js
// Schema for banquet & venues

const mongoose = require('mongoose');

const RequestSchema = new mongoose.Schema({
  eventType: {
    type: String,
    required: true,
  },
  country: {
    type: String,
    required: true,
  },
  state: {
    type: String,
    required: true,
  },
  city: {
    type: String,
    required: true,
  },
  eventDates: {
    type: [Date],
    required: true,
  },
  numberOfAdults: {
    type: Number,
    required: true,
  },
  cateringPreference: {
    type: String,
    required: true,
  },
  cuisines: {
    type: [String],
    required: true,
  },
  budget: {
    type: String,
    required: true,
  },
  offerWithin: {
    type: String,
    required: true,
  },
  submittedAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Request', RequestSchema);