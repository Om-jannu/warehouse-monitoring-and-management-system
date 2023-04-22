const firebase = require('firebase');

// take credentials from firebase web

const config = {
  apiKey: 'AIzaSyCAKx2DH0d2joyyJILRMrzo1-3h8AK0Sao',
  authDomain: 'http://invsync-f07e2.firebaseapp.com',
  databaseURL: 'https://invsync-f07e2-default-rtdb.firebaseio.com/',
  projectId: 'invsync-f07e2',
  storageBucket: 'http://invsync-f07e2.appspot.com',
  messagingSenderId: '478966296027',
  appId: '1:478966296027:android:4787a9ad6fd64f05e28bfe'
};

// initialize it 

firebase.initializeApp(config);
const db = firebase.database();

//set up backend and port

const express = require('express');
const app = express();
const port = 3000;

//generate random values for the temp, humidity and co2 along with timestamp

function generateRandomValue(min, max) {
  return Math.random() * (max - min) + min;
}

// use api with get request to create a record

app.get('/addData', (req, res) => {
  const temperature = generateRandomValue(10, 45);
  const humidity = generateRandomValue(40, 90);
  const co2 = generateRandomValue(300, 1000);

//   const timestamp = new Date().toLocaleString('en-IN', { timeZone: 'Asia/Kolkata' });

const date = new Date().toLocaleString('en-US', { timeZone: 'Asia/Kolkata' });
const timestamp = new Date(date).toISOString();
console.log(timestamp); // output: 2023-04-22T19:30:12.000Z


  // Append the generated data to the Firebase database
  db.ref('sensorData').push({
    temperature: temperature,
    humidity: humidity,
    co2: co2,
    timestamp: timestamp
  }, (error) => {
    if (error) {
      res.status(500).send('Error adding data to database');
    } else {
      res.send('Data added to database');
    }
  });
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
