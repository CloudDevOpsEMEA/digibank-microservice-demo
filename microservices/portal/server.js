'use strict';
const express = require('express');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const session = require('express-session');
const mongoose = require('mongoose');
const mongostore = require('connect-mongo')(session);
const request = require('request');

var app = express();

app.use(express.static(`${__dirname}/public`));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.use(cookieParser());
app.use(session({
    secret: process.env.SESSION_SECRET,
    store: new mongostore({url: process.env.MONGO_URL}),
    resave: true,
    saveUninitialized: true,
    cookie: {
        cookieName: 'connect.sid',
        secret: process.env.SESSION_SECRET,
        httpOnly: false,
        secure: false,
        ephemeral: true
    }
}));

require('./routes/auth')(app);
require('./routes/user')(app, request);
require('./routes/bills')(app, request);
require('./routes/accounts')(app, request);
require('./routes/transactions')(app, request);
require('./routes/support')(app, request);
require('./routes/health')(app);

var port = process.env.PORT;

console.log(`Running on ${port}, connecting to ${process.env.MONGO_URL}`)

mongoose.connect(process.env.MONGO_URL, { useNewUrlParser: true , useUnifiedTopology: true },
    function (ignore, connection) {
        connection.onOpen();
        app.listen(port, function () {
            console.log('Innovate portal running on port: %d', port);
        });
    }
);
