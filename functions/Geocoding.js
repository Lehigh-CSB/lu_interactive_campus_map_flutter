// just a testing file

const NodeGeocoder = require('node-geocoder');
require('dotenv').config();

const options = {
    provider: 'google',
    apiKey: process.env.GEOCODING_API_KEY,
};

const geocoder = NodeGeocoder(options);

// const res = geocoder.geocode({address: 'Linderman Library, Grand Reading Room'});

// res.then((result) => {
//     console.log(result[0].latitude);
//     console.log(result[0].longitude);
// });

// const res = geocoder.geocode({address: 'Linderman Library, Grand Reading Room'});

var location = 'Linderman Library, Grand Reading Room';

(async function(){
    const res = await geocoder.geocode({address: location});
    console.log(res)
})()