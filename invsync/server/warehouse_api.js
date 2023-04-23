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

// set up backend and port

const express = require('express');
const app = express();
const port = 3000;

// generate random values for the temp, humidity and co2 along with timestamp

function generateRandomValue(min, max) {
  return Math.random() * (max - min) + min;
}

// use api with get request to create records with 5 minute difference

app.get('/addData', (req, res) => {
  const startTime = new Date().getTime() - 43200000; // 12 hours in milliseconds
  const endTime = new Date().getTime();
  const timeDifference = 300000; // 5 minutes in milliseconds
  let timestamp = new Date(startTime);
  while (timestamp.getTime() < endTime) {
    const temperature = generateRandomValue(10, 45);
    const humidity = generateRandomValue(40, 90);
    const co2 = generateRandomValue(300, 1000);
    const newRecordRef = db.ref('sensorData').push({
      temperature: temperature,
      humidity: humidity,
      co2: co2,
      timestamp: timestamp.toISOString()
    }, (error) => {
      if (error) {
        console.log('Error adding data to database');
      } else {
        console.log('Data added to database with ID:', newRecordRef.key);
      }
    });
    timestamp = new Date(timestamp.getTime() + timeDifference);
  }
  res.send('Data added to database');
});


app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});