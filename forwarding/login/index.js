/**
 * Receive & process get/post requests about login
 *  - Serve back logged-in page on success
 *  - Needs to be aware of both the auth (get) & loggedIn (successful post)
 */


// Load required modules
const 
    https = require('https'), 
    express = require('express'),
    path = require('path'),
    fs = require('fs'),
    crypto = require('crypto')
;


// Load cert and create server
const options = {
    key: fs.readFileSync(`..\\..\\certs\\key.pem`),
    cert: fs.readFileSync(`..\\..\\certs\\cert.pem`)
};
const
    router = express(),
    server = https.createServer(options, router)
;

// Initialize express and add resolve main dir to /auth endpoint
router.use(express.urlencoded({extended: true}));
router.use(express.json());
router.use('/auth', express.static(path.resolve(__dirname, 'auth')));


// For get requests to auth to the login server
router.post("/login", function(req, resp) {

    // Handle how to serve back content
    console.log(req.body);
    let valid = true;
    resp.set('Content-Type', 'text/html; charset=utf-8');
    resp.set('X-Content-Type-Options', 'no-sniff');
    if (!valid) {

        // Serve back an error
        resp.status(200);
        let msg = `
            <h1>Error: 401, invalid login attempt</h1>
        `;
        console.log("Sending back error");
        resp.end(msg);

    } else {

        // Initalize response & variables
        resp.status(200);
        let output, term, userToken;
        const hash = crypto.createHash('sha256');

        // Salt input
        userToken = crypto.randomUUID();
        term = userToken + req.body.password;
        output = hash.update(term, 'utf-8').digest('hex'); // Could use something similar for a session key DB for validating timestamps
        console.log(`Input: ${req.body.password}\nSalt: ${userToken}\nCommit: ${output}`);

        // Send file
        resp.sendFile( (path.resolve(__dirname, 'loggedIn') + '/index.html') );
    }

    // End response
    // resp.end();
});


// Start server
server.listen(process.env.PORT || 8081, process.env.IP || '127.0.0.1', function() {
    let srvrAddr = server.address();
    console.log(`Server listening on port = ${srvrAddr.port}, address = ${srvrAddr.address}`);
});