/**
 * 
 */

// Server and additional modules
const https = require('https'); // Works fine with HTTP, does not with HTTPS

const express = require('express'),
    path = require('path'),
    fs = require('fs');

// Cert options
const options = {
    key: fs.readFileSync('../certs/private-key.pem'),
    cert: fs.readFileSync('../certs/awsCourse.pem')
};

// Create server
const router = express();
const server = https.createServer(router, options);

// Set router options
router.use( express.static(path.resolve(__dirname, 'views') ) );
router.use(express.json);

// Bind server to port and ip
console.log(`Port = ${process.env.PORT}, IP = ${process.env.IP}`);
server.listen(process.env.PORT || 8000, process.env.IP || '0.0.0.0', function() {
    let srvrAddr = server.address();
    console.log(`Server listening on port = ${srvrAddr.port}, address = ${srvrAddr.address}`);
    console.log(`Current directory: ${process.cwd()}`);
    console.log(`Server directory: ${path.resolve(__dirname, 'views')}`);
})

