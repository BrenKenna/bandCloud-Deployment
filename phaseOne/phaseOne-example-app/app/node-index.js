/**
 * 
 */

// Server and additional modules
const http = require('http'); // Works fine with HTTP, does not with HTTPS

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
const router = express();
const server = http.createServer(router);


// Set router options
router.use( express.static(path.resolve(__dirname, 'views') ) );
router.use(express.urlencoded({extended: true}));
router.use(express.json);
router.use(express.static('/yolo'));


router.get('/get', function(req, res) {

    // Initialize header
    console.log("Request recieved");
    // res.writeHead(200, {'Content-Type': 'application/json'});

    // Resolve promise
    let ec2_response = JSON.stringify({'Overwritten': false});
    /* requestPromise.then(function(data) {
        ec2_response = JSON.stringify(ec2_util.parseInfo(data));
        res.send(ec2_response);
    });
    */

    // Serve request
    // res.send(ec2_response);
    res.end(ec2_response);

});

// Bind server to port and ip
// console.log(`Port = ${process.env.PORT}, IP = ${process.env.IP}`);
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