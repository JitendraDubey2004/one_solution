// schema for travel & stay part

const mongoose = require('mongoose');

const TravelRequestSchema = new mongoose.Schema({
  holidayType: {
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
  checkInDate: {
    type: Date,
    required: true,
  },
  checkOutDate: {
    type: Date,
    required: true,
  },
  numberOfAdults: {
    type: Number,
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

module.exports = mongoose.model('TravelRequest', TravelRequestSchema);