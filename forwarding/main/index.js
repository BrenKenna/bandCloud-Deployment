/**
 * Asks the login server for the form and posts input
 *  - Effectively get & post requests are relayed to another server
 * 
 * Serves messages back to the user from the login server
 *  - That severs responses are relayed back to end-user
 */

// Load required modules
const 
    https = require('https'), 
    express = require('express'),
    path = require('path'),
    fs = require('fs'),
    axios = require('axios')
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


// Configure axios to allow self-signed certs for debugging
const instance = axios.create({
    httpsAgent: new https.Agent({  
      rejectUnauthorized: false
    })
  });

// Initialize express and add resolve main dir to /main endpoint
router.use(express.urlencoded({extended: true}));
router.use(express.json());
router.use('/', express.static(path.resolve(__dirname, 'views')));


// For get requests to auth to the login server
const httpsAgent = new https.Agent( {rejectUnauthorized: false} ); // Allow self-signed for debugging
router.get("/auth", function(req, resp) {

    // Serve back HTML
    resp.writeHead(200, {'Content-Type': 'text/html'});

    // Fetch promise for the auth page
    let data = instance.get('https://localhost:8081/auth');
    
    // Resolve promise
    data.then( function(res) {
        resp.end(res.data);
    });

});


// For forwarding post to login
router.post('/login', function(req, resp) {

    // Parse input
    let userData = {
        username: req.body.username,
        password: req.body.password
    };
    // console.log(userData);

    // Fetch promise for login
    let data = instance.post('https://localhost:8081/login', userData);
    data.then( function(res) {
        resp.end(res.data);
    });
});


// Start server
server.listen(process.env.PORT || 8080, process.env.IP || '127.0.0.1', function() {
    let srvrAddr = server.address();
    console.log(`Server listening on port = ${srvrAddr.port}, address = ${srvrAddr.address}`);
});