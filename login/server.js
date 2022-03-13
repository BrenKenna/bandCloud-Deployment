/**
 * HTTPS Server(s) + REST API to Validate Register/Login
 * 
 * Main aim atm is a boilerplate from which more advanced concepts can be added
 * 
 *  - Review crypto documentation for updating
 *  - Store the commit for the register (Local for now)
 *  - Separate login from register
 *  - Continue notes on related event validation + expand content
 *  - Continue notes on recieved requests + expected body sizes ;)
 *      => Be cool to be able to decrypt some of the messages yourself
 *          with the self-signed cert key :)
 */

// Load required modules
 const 
    https = require('https'), 
    express = require('express'),
    path = require('path'),
    fs = require('fs'),
    crypto = require('crypto')
;


// Packages & Concepts to check out later
// const cors = require("cors");
// const cookieSession = require("cookie-session");


// Load cert and create server
const options = {
    key: fs.readFileSync(`..\\certs\\key.pem`),
    cert: fs.readFileSync(`..\\certs\\cert.pem`)
};
const
    router = express(),
    server = https.createServer(options, router)
;

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

    // Generate random token <= Outside of managing promise. Additional considerations from crypto + commited digest + string inputs
    crypto.randomBytes(48, function(err, buffer) {

        // Initalize variable
        let output, term, userToken;
        const hash = crypto.createHash('sha256'); // Currently every single post is unique

        // Alternative + no promise
        salt = crypto.randomUUID();

        // Translate password
        userToken = buffer.toString('hex');
        term = userToken + req.body.password;
        output = hash.update(term, 'utf-8').digest('hex'); // Could use something similar for a session key DB for validating timestamps
        console.log(`Input: ${req.body.password}\nSalt: ${userToken}\nCommit: ${output}\nAlt-Salt: ${salt}`);
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