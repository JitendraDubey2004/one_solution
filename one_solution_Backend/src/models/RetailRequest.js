// schema for  retail stores & shops part

const mongoose = require('mongoose');

const RetailRequestSchema = new mongoose.Schema({
  serviceType: {
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

module.exports = mongoose.model('RetailRequest', RetailRequestSchema);