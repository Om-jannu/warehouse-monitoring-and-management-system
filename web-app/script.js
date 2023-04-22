// Define the limit values for each field
const field1Limit = 35;
const field2Limit = 50;
const field3Limit = 800;

// Function to fetch the latest data from the ThingSpeak API and check for limit exceedance
fetch('https://api.thingspeak.com/channels/2102593/feeds.json?results=1')
    .then(response => response.json())
    .then(data => {
      const feed = data.feeds[0];

      const field1Value = parseFloat(feed.field1);
      const field2Value = parseFloat(feed.field2);
      const field3Value = parseFloat(feed.field3);

      if (field1Value > field1Limit) {
        console.log(`Field 1 value (${field1Value}) has exceeded the limit of ${field1Limit}.`);
        sendEmail("temperature",field1Value,field1Limit);
        alert(`Field 1 value (${field1Value}) has exceeded the limit of ${field1Limit}.`);
      }

      if (field2Value > field2Limit) {
          console.log(`Field 2 value (${field2Value}) has exceeded the limit of ${field2Limit}.`);
        sendEmail("Humidity",field2Value,field2Limit);
          alert(`Field 2 value (${field2Value}) has exceeded the limit of ${field2Limit}.`);
      }

      if (field3Value > field3Limit) {
        console.log(`Field 3 value (${field3Value}) has exceeded the limit of ${field3Limit}.`);
        sendEmail("CO2",field3Value,field3Limit);
        alert(`Field 3 value (${field3Value}) has exceeded the limit of ${field3Limit}.`);
      }
    })
    .catch(error => console.error(error));
function checkData() {
  fetch('https://api.thingspeak.com/channels/2102593/feeds.json?results=1')
    .then(response => response.json())
    .then(data => {
      const feed = data.feeds[0];

      const field1Value = parseFloat(feed.field1);
      const field2Value = parseFloat(feed.field2);
      const field3Value = parseFloat(feed.field3);

      if (field1Value > field1Limit) {
        console.log(`Field 1 value (${field1Value}) has exceeded the limit of ${field1Limit}.`);
        alert(`Field 1 value (${field1Value}) has exceeded the limit of ${field1Limit}.`);
      }

      if (field2Value > field2Limit) {
          console.log(`Field 2 value (${field2Value}) has exceeded the limit of ${field2Limit}.`);
          alert(`Field 2 value (${field2Value}) has exceeded the limit of ${field2Limit}.`);
      }

      if (field3Value > field3Limit) {
        console.log(`Field 3 value (${field3Value}) has exceeded the limit of ${field3Limit}.`);
        alert(`Field 3 value (${field3Value}) has exceeded the limit of ${field3Limit}.`);
      }
    })
    .catch(error => console.error(error));
}

// Set up the interval to periodically check the data
setInterval(checkData, 900000); // Check every 15 minutes (adjust as needed)
