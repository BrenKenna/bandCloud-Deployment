/**
 * 
 */

// Server and additional modules
// const http = require('http'); // Works fine with HTTP, does not with HTTPS

const express = require('express'),
    path = require('path'),
    fs = require('fs');

// Get EC2 function
const AWS = require('aws-sdk'),
    ec2_util = require('/home/ec2-user/hostedApp/node_modules/utils/aws/ec2_summary.js');
let requestPromise = ec2_util.getInfo(AWS, 'eu-west-1');
requestPromise.then(function(data) {
    console.log(ec2_util.parseInfo(data).InstanceId);
});

// Cert options
/*
const options = {
    key: fs.readFileSync('../certs/key.pem'),
    cert: fs.readFileSync('../certs/cert.pem')
};
*/

// Create server
const app = express();
const serveIndex = require('serve-index');
// const server = http.createServer(router);


// Display time and date in console
app.use((req, res, next) => {
    console.log('Time: ', Date.now());
    next(); // So request does not get stuck
});

// For serving homepage
app.use('/', express.static(path.resolve(__dirname, 'views')));
app.use('/', serveIndex('views'));

// For serving the vm details page
app.use('/instance', express.static( path.resolve(__dirname, 'instance') ));
app.use('/instance', serveIndex('instance'));


// Path for an endpoint
app.use('/request-type', (req, res, next) => {
    console.log('Request type: ', req.method);
    next();
});


// Desired
app.get('/details', function(req, res) {

    // Initialize header
    res.writeHead(200, {'Content-Type': 'application/json'});

    // Resolve promise
    let ec2_response = JSON.stringify({'Overwritten': false});
    requestPromise.then(function(data) {
        ec2_response = JSON.stringify(ec2_util.parseInfo(data));
        res.end(ec2_response);
    });
});

// Bind server to port and ip
app.listen(8080, '0.0.0.0', function() {
    // Log instance details
    requestPromise.then(function(data) {
        console.log(ec2_util.parseInfo(data));
    });
});