// File: src/controllers/geoController.js
// file contains the controller functions for the Country, State & City feature and business logic for geting Country, State & City

exports.getCountries = (req, res) => {
  const countries = ['India', 'China', 'Japan', 'Russia'];
  res.status(200).json(countries);
};

exports.getStates = (req, res) => {
  const { country } = req.query;
  let states = [];

  if (country === 'India') {
    states = ['Maharashtra', 'Delhi', 'Karnataka'];
  } else if (country === 'China') {
    states = ['Hebei', 'Sichuan', 'Guangdong'];
  } else if (country === 'Japan') {
    states = ['Tokyo', 'Osaka', 'Kyoto'];
  } else if (country === 'Russia') {
    states = ['Moscow Oblast', 'Sverdlovsk Oblast', 'Republic of Tatarstan'];
  } else {
    states = [];
  }
  res.status(200).json(states);
};

exports.getCities = (req, res) => {
  const { state } = req.query;
  let cities = [];

  if (state === 'Maharashtra') {
    cities = ['Powai', 'Mumbai', 'Pune', 'Nagpur'];
  } else if (state === 'Delhi') {
    cities = ['New Delhi', 'Delhi'];
  } else if (state === 'Karnataka') {
    cities = ['Bangalore', 'Mysore', 'Hubli'];
  } else if (state === 'Hebei') {
    cities = ['Shijiazhuang', 'Baoding'];
  } else if (state === 'Sichuan') {
    cities = ['Chengdu', 'Mianyang'];
  } else if (state === 'Guangdong') {
    cities = ['Guangzhou', 'Shenzhen'];
  } else if (state === 'Tokyo') {
    cities = ['Shinjuku', 'Shibuya', 'Chiyoda'];
  } else if (state === 'Osaka') {
    cities = ['Sakai', 'Higashiosaka'];
  } else if (state === 'Kyoto') {
    cities = ['Uji', 'Nagaokakyo'];
  } else if (state === 'Moscow Oblast') {
    cities = ['Moscow', 'Balashikha'];
  } else if (state === 'Sverdlovsk Oblast') {
    cities = ['Yekaterinburg', 'Nizhny Tagil'];
  } else if (state === 'Republic of Tatarstan') {
    cities = ['Kazan', 'Naberezhnye Chelny'];
  } else {
    cities = [];
  }
  res.status(200).json(cities);
};