/**
 * 
 */

// Server and additional modules
const https = require('http'), 
    express = require('express'),
    path = require('path'),
    fs = require('fs');

// Get EC2 function
const AWS = require('aws-sdk'),
    ec2_util = require(`${process.cwd()}/utils/aws/ec2/ec2_summary.js`);

let requestPromise = ec2_util.getInfo(AWS, 'eu-west-1');
requestPromise.then(function(data) {
    console.log(ec2_util.parseInfo(data).InstanceId);
});

// Cert options
const options = {
    key: fs.readFileSync(`${process.cwd()}/certs/key.pem`),
    cert: fs.readFileSync(`${process.cwd()}/certs/cert.pem`)
};

// Create server
const app = express();
const serveIndex = require('serve-index');


// For serving homepage
app.use('/', express.static(path.resolve(__dirname, 'views')));

// For serving the vm details page
app.use('/instance', express.static( path.resolve(__dirname, 'instance') ));


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


// Create https server
const server = https.createServer(app);
server.listen(process.env.PORT || 8080, process.env.IP || '0.0.0.0', function() {
    let srvrAddr = server.address();
    console.log(`Server listening on port = ${srvrAddr.port}, address = ${srvrAddr.address}`);
    console.log(`Current directory: ${process.cwd()}`);
    console.log(`Server directory: ${path.resolve(__dirname, 'views')}`);
    
    // Log instance details
    requestPromise.then(function(data) {
        console.log(ec2_util.parseInfo(data));
    });
})