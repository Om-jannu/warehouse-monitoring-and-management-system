const express = require('express');
const nodemailer = require('nodemailer');
const { google } = require('googleapis');
const { OAuth2 } = google.auth;
const client_secret = require('./client_secret_474604492516-d44810u318r3hnfhoiktiqneagrfi335.apps.googleusercontent.com.json');

const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Hello World!');
});
app.get('/api/sendmail', (req, res) => {
    try {
        
        const { field, value, limit } = req.query;
        const oauth2Client = new OAuth2(
            client_secret.web.client_id,
            client_secret.web.client_secret,
            client_secret.web.redirect_uris // Redirect URL
          );
          oauth2Client.setCredentials({
            refresh_token: client_secret.web.refresh_token
          });
          const accessToken = oauth2Client.getAccessToken();
            // Create a transporter object to connect to a mail server
      
          const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
              type: 'OAuth2',
              user: 'cluedin.dbit@gmail.com',
              clientId: client_secret.web.client_id,
              clientSecret: client_secret.web.client_secret,
              refreshToken: client_secret.web.refresh_token,
              accessToken: accessToken
            }
          });
        const sendEmail = (field, value, limit) => {
            // Set up the email message
            const message = {
                from: 'cluedin.dbit.gmail.com',
                to: 'cluedin.dbit.gmail.com',
                subject: `Limit exceeded for ${field} value`,
                text: `The ${field} value (${value}) has exceeded the limit of ${limit}.`
            };

            // Send the email
            transporter.sendMail(message, (error, info) => {
                if (error) {
                    console.error(error);
                } else {
                    console.log(`Email sent: ${info.response}`);
                }
            });
        }
        console.log(field, value, limit);
        sendEmail(field, value, limit);
        res.status(200).send({ 'message': "email send succesfullt" })
    } catch (error) {
        res.status(400).send({ 'message': "internal server error" });
    }
});

app.listen(port, () => {
    console.log(`Server listening at http://localhost:${port}`);
});
