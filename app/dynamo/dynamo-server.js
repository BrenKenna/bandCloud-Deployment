/**
 * Get and Put Items to DynamoDB
 * 
 * {"username":"webTest","password":"IKnowRight:c","email":"yolo@yomomma.com"}
 * 
 */

// Imports
const https = require('http'), 
    express = require('express'),
    path = require('path'),
    AWS = require('aws-sdk'),
    crypto = require('crypto'),
    cookieParser = require('cookie-parser')
;


// DynamoDB service object
AWS.config.update({region: 'eu-west-1'});
const dynamoDB = new AWS.DynamoDB({apiVersion: '2012-08-10'});

// Configure server
const
    router = express(),
    server = https.createServer(router);
;
router.use(express.urlencoded({extended: true}));
router.use(express.json());


// For serving pages
router.use('/', express.static(path.resolve(__dirname, 'main')));
router.use('/registration', express.static(path.resolve(__dirname, 'registration')));
router.use('/auth', express.static(path.resolve(__dirname, 'auth')));
app.use(express.cookieParser());


// Registration endpoint
router.post('/reg', function(req, resp) {

    // Initailze response
    let valid = true;
    resp.set('Content-Type', 'text/html; charset=utf-8');
    resp.set('X-Content-Type-Options', 'no-sniff');

    // Format password
    let userTerm, userToken;
    const hash = crypto.createHash('sha256');
    userToken = crypto.randomUUID();
    userTerm = (req.body.password.replace("'", "") + userToken);
    userTerm = hash.update(userTerm, 'utf-8').digest('hex');


    // Format query
    let params = {
        TableName: 'BandCloud_User',
        Item: {
          'Username' : {S: `${req.body.username}`},
          'Email' : {S: `${req.body.email}`},
          'Credentials': {M: {
              'Password': {S: `${userTerm}`},
              'Salt': {S: `${userToken}`}
          }},
          'Session': {M: {
              'Token': {S: ``},
              'Issue Date': {S: ``}
          }}
        }
    };


    // Call DynamoDB to add the item to the table
    dynamoDB.putItem(params, function(err, data) {
        if (err) {

            // Log error locally & send page back to client
            console.log({"Error-Register": err});
            resp.status(201); // Change to proper error code laterz
            let msg = `
                <h1>Error creating account '${req.body.username}'</h1>
            `;
            resp.end(msg);

        } else {

            // Send and handle response with api key
            let apiKey = hash.update(crypto.randomUUID(), 'utf-8').digest('hex');
            resp.status(200);
            resp.cookie('auth', apiKey, { maxAge: (24 * 60 * 60 * 1000), httpOnly: true }); // 24 hours
            resp.sendFile( (path.resolve(__dirname, 'homepage') + '/index.html') );
        }
    });
});


// Login endpoint
router.post('/login', function(req, resp) {

    // Initailze response
    let valid = true;
    resp.set('Content-Type', 'text/html; charset=utf-8');
    resp.set('X-Content-Type-Options', 'no-sniff');

    // Get user data: ProjectionExpression: 'Credentials'
    let params = {
        TableName: 'BandCloud_User',
        Key: {
          'Username': {S: `${req.body.username}`}
        }
    };
    dynamoDB.getItem(params, function(err, data) {
        if (err) {
            console.log({"Error-Register": err});
            resp.status(201); // Change to proper error code laterz
            let msg = `
                <h1>Error no account exists for '${req.body.username}'</h1>
            `;
            resp.end(msg);
        } else {
          
          // Initialize
          let userCommit, userToken, userTerm;
          const hash = crypto.createHash('sha256');
          console.dir(data, {depth: null});
          userCommit = data.Item.Credentials.M.Password.S;
          userToken = data.Item.Credentials.M.Salt.S;

          // Digest & compare
          userTerm = (req.body.password + userToken);
          userTerm = hash.update(userTerm, 'utf-8').digest('hex');
          valid = (userCommit === userTerm);

          if(valid) {
            resp.status(200);  
            resp.sendFile( (path.resolve(__dirname, 'homepage') + '/index.html') );
          }
          else {
            resp.status(201); // Change to proper error code laterz
            // console.log(userCommit + " != " + userTerm);
            let msg = `
                <h1>Error incorrect login '${req.body.username}'</h1>
            `;
            resp.end(msg);
          }
        }
      });
});


// Create https server
server.listen(process.env.PORT || 8080, process.env.IP || '0.0.0.0', function() {
    let srvrAddr = server.address();
    console.log(`Register/Login Server listening on port = ${srvrAddr.port}, address = ${srvrAddr.address}`);
    console.log(`Current directory: ${process.cwd()}`);
})