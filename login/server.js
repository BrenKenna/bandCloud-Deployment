/**
 * HTTPS Server + REST API to Validate Login
 * 
 */

// Load required modules
 const 
    https = require('https'), 
    express = require('express'),
    path = require('path'),
    fs = require('fs'),
    crypto = require('crypto');


// Packages & Concepts to check out later
// const cors = require("cors");
// const cookieSession = require("cookie-session");


// Load cert and create server
const options = {
    key: fs.readFileSync(`..\\certs\\key.pem`),
    cert: fs.readFileSync(`..\\certs\\cert.pem`)
};
const router = express();
const server = https.createServer(options, router);

// Initialize express and add resolve main dir to /main endpoint
router.use(express.urlencoded({extended: true}));
router.use(express.json());
router.use('/', express.static(path.resolve(__dirname, 'main')));
// router.use('/', serveIndex('main')); // Different way of doing the above

// Serve login form
router.get('/auth', express.static(path.resolve(__dirname, 'auth')));

// Endpoint to post login form to
router.post('/login', (req, res) => { 

    // For debugging
    console.log(req.body);
    res.send(req.body);

    // Generate random token <= Additional considerations from crypto + commited digest + string inputs
    crypto.randomBytes(48, function(err, buffer) {

        // Initalize variable
        let output, term, userToken;
        const hash = crypto.createHash('sha256');

        // Translate password
        userToken = buffer.toString('hex');
        term = userToken + req.body.password;
        output = hash.update(term, 'utf-8').digest('hex');
        console.log(`Input: ${req.body.password}\nSalt: ${userToken}\nCommit: ${output}`);
    });
    
    /**
     * Continue reading about some of the properties
     *  console.log(req);
     */
});


// Start server
server.listen(process.env.PORT || 8080, process.env.IP || '127.0.0.1', function() {
    let srvrAddr = server.address();
    console.log(`Server listening on port = ${srvrAddr.port}, address = ${srvrAddr.address}`);
    console.log(`Current directory: ${process.cwd()}`);
    console.log(`Server directory: ${path.resolve(__dirname, 'main')}`);
});