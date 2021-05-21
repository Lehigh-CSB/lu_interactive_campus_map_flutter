const functions = require('firebase-functions');
const puppeteer = require("puppeteer");
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const NodeGeocoder = require('node-geocoder');

const options = {
  provider: 'google',
  apiKey: process.env.GEOCODING_API_KEY,
};

const geocoder = NodeGeocoder(options);


exports.parseEvents = functions.runWith({memory: '4GB', timeoutSeconds: 539}).pubsub.schedule("every 12 hours")
    .timeZone("America/New_York").onRun(async (context) => {
        
        const browser = await puppeteer.launch({args: ['--no-sandbox']});
        const page = await browser.newPage();
        await page.setDefaultNavigationTimeout(0);
        await page.goto("https://eventscalendar.lehigh.edu/calendar/");

        const data = await page.evaluate(() => {
            let events = []
            let titles = document
              .getElementsByClassName("summary");
            let descriptions = document
              .getElementsByClassName("description");
            let dates = document
              .getElementsByClassName("dateright");
            let locations = document
              .getElementsByClassName("location");
            let img_urls = document
              .getElementsByClassName("img_big_square");
            let event_urls = document
              .getElementsByClassName("box_left");
        
            for(var i = 0; i < titles.length; i++){
                events.push({
                  title: titles[i].textContent
                    .replace(/(\r\n|\n|\r)/gm, "")
                    .replace(/^\s+|\s+$/g, "")
                    .replace(/\t+/g,""),
                  description: descriptions[i].textContent
                    .replace(/(\r\n|\n|\r)/gm, "")
                    .replace(/^\s+|\s+$/g, "")
                    .replace(/\t+/g,""),
                  date: dates[i].textContent
                    .replace(/(\r\n|\n|\r)/gm, "")
                    .replace(/^\s+|\s+$/g, "")
                    .replace(/\t+/g,"")
                    .replace(/\s+/g, " ")
                    .trim(),
                  location: locations[i].textContent
                    .replace(/(\r\n|\n|\r)/gm, "")
                    .replace(/^\s+|\s+$/g, "")
                    .replace(/\t+/g,""),
                  img_url: img_urls[i].src,
                  event_url: event_urls[i].href
                })
            }
        
            return events;
        });

        for(var i = 0; i < data.length; i++){
            const page_event = await browser.newPage();
            await page_event.setDefaultNavigationTimeout(0);
            await page_event.goto(data[i].event_url);

            const data_full = await page_event.evaluate((data) => {
              let events_full = [];
              let address = '';
              if(data[i].location != 'Virtual Event' || data[i].location != ''){
                  address = document.querySelector('.location');
              }
              let full_description = document.querySelector('.description').textContent;

              if(address == '' || address == null){
                events_full.push({
                    address: 'Lehigh University',
                    full_description: full_description.replace(/(\r\n|\n|\r)/gm, "").replace(/^\s+|\s+$/g, '').replace(/\t+/g,'')
                });
              }
              else{
                events_full.push({
                    address: address.textContent.replace(/(\r\n|\n|\r)/gm, "").replace(/^\s+|\s+$/g, '').replace(/\t+/g,''),
                    full_description: full_description.replace(/(\r\n|\n|\r)/gm, "").replace(/^\s+|\s+$/g, '').replace(/\t+/g,'')
                });
              }
              return events_full;
            }, data);

            if(data_full[0].address != ''){
              console.log(data_full[0].address);
              const res = geocoder.geocode({address: data[i].location, zipcode: '18015'});
              res.then((result) => {
                admin.database().ref("events/event_" + i).set({
                  "title": data[i].title,
                  "description": data[i].description,
                  "date": data[i].date,
                  "location": data[i].location,
                  "img_url": data[i].img_url,
                  "event_url": data[i].event_url,
                  "address": data_full[0].address,
                  "full_description": data_full[0].full_description,
                  'latitude': result[0].latitude,
                  'longitude': result[0].longitude,
                });
              });
            }
            else{
              admin.database().ref("events/event_" + i).set({
                "title": data[i].title,
                "description": data[i].description,
                "date": data[i].date,
                "location": data[i].location,
                "img_url": data[i].img_url,
                "event_url": data[i].event_url,
                "address": data_full[0].address,
                "full_description": data_full[0].full_description,
                'latitude': '40.6048687',
                'longitude': '-75.3775187',
              });
            }

            console.log('Writing to the database of event #' + i + ' is complete!');
        }

        await browser.close();
        
        return null;
    });