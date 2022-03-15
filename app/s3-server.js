// Server and additional modules
const https = require('http'), 
    express = require('express'),
    path = require('path'),
    fs = require('fs');

// AWS Utils
const 
    AWS = require('aws-sdk'),
    region = 'eu-west-1',
    ec2_util = require(`${process.cwd()}/utils/aws/ec2/ec2_summary.js`),
    s3_util = require(`${process.cwd()}/utils/aws/s3/s3_read_write.js`)
;
const clientS3 = new AWS.S3({apiVersion: '2014-10-01', 'region': region});
let ec2Prom = ec2_util.getInfo(AWS, 'eu-west-1');
let s3Prom = s3_util.listPromise();

// Create & configure server
const
    router = express(),
    server = https.createServer(router);
;
router.use(express.urlencoded({extended: true}));
router.use(express.json());


// For serving homepage
router.use('/', express.static(path.resolve(__dirname, 'views')));


// For serving s3 bucket data as JSON
let nRequests = 0;
router.get('/bucket', function(req, res) {

    // Initialize header
    res.writeHead(200, {'Content-Type': 'application/json'});

    // Resolve promise
    s3Prom.then(function(data) {
        let s3_response, names;
        names = [];
        for(i of data.Buckets){
            names.push(i.Name);
        }
        s3_response = JSON.stringify({'Bucket-Names': names});
        res.end(s3_response);
    });

    // Note
    nRequests++;
    console.log(`N requests served = ${nRequests}`);
});


// Drop bucket: testingbucket-2
router.use('/s3_drop', express.static(path.resolve(__dirname, 's3_drop')));
router.post('/drop', function(req, resp) {

    // Initialize header
    resp.set('Content-Type', 'text/html; charset=utf-8');
    resp.set('X-Content-Type-Options', 'no-sniff');
    let bucketParams = {
        'Bucket': req.body.Bucket_Name
    };

    // Call S3 to delete the bucket
    clientS3.deleteBucket(bucketParams, function(err, data) {
        if (err) {

            // Message
            let msg = `
                <h1>Your request for deletion of '${req.body.Bucket_Name}' has been recieved</h1>
            `;
            console.log({"Error-S3-Deletion": err});
            resp.end(msg);

        } else {

            // Message
            let msg = `
                <h1>Requested bucket '${req.body.Bucket_Name}' has been deleted</h1>
            `;
            resp.end(msg);
        }
    });
});


// Create https server
server.listen(process.env.PORT || 8080, process.env.IP || '0.0.0.0', function() {
    let srvrAddr = server.address();
    console.log(`Server listening on port = ${srvrAddr.port}, address = ${srvrAddr.address}`);
    console.log(`Current directory: ${process.cwd()}`);
    console.log(`Server directory: ${path.resolve(__dirname, 'views')}`);
    
    // Log instance details
    console.log("\nListing S3 Bucket Names:\n")
    s3_util.printBucket(s3Prom);
})