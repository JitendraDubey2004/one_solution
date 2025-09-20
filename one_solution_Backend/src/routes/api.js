// File: src/routes/api.js

const express = require('express');
const router = express.Router();
const banquetsController = require('../controllers/banquetsController');
const travelController = require('../controllers/travelController');
const retailController = require('../controllers/retailController');
const geoController = require('../controllers/geoController');

// endpoints for getting home page images
router.get('/categories', (req, res) => {
  const categories = [
    {
      "id": 1,
      "name": "Travel & Stay",
      "imageUrl": "https://images.unsplash.com/photo-1566073771259-6a8506099945?fit=crop&q=80&w=1740&auto=format&fit=crop",
      "icon": "hotel"
    },
    {
      "id": 2,
      "name": "Banquets & Venues",
      "imageUrl": "https://images.pexels.com/photos/33914530/pexels-photo-33914530.jpeg",
      "icon": "event"
    },
    {
      "id": 3,
      "name": "Retail stores & Shops",
      "imageUrl": "https://retailblog.jll.com/wp-content/uploads/2017/06/shutterstock_342916385-Philly-Market-East-Reading-terminal.jpg",
      "icon": "store"
    }
  ];
  res.status(200).json(categories);
});

router.post('/banquets-venues/requests', banquetsController.submitRequest);
router.post('/travel-stay/requests', travelController.submitRequest);
router.post('/retail-shops/requests', retailController.submitRequest);


//  endpoints for getting country, state and city
router.get('/countries', geoController.getCountries);
router.get('/states', geoController.getStates);
router.get('/cities', geoController.getCities);

module.exports = router;