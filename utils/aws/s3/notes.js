/**
 * Notes on the S3 Client
 *  - References: 
 *      Main = https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-s3/index.html
 *      S3 Methods = https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-s3/classes/s3.html
 *      S3 Params = https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/S3.html
 *                      - Quite a few ACLS private | public-read | public-write
 * 
 *      S3 List bucket = https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/S3.html#listBuckets-property
 */

// Importing
const region = 'eu-west-1';
const AWS = require('aws-sdk');
const clientS3 = new AWS.S3({apiVersion: '2014-10-01', 'region': region});


// Getting a create bucket
let params;
params = {
    Bucket: 'testingbucket-2',
    ACL: 'private'
};
clientS3.createBucket(params, function(err, data) {
    if (err) {
      console.log("Error", err);
    } else {
      console.log(data.Location);
    }
});


// List buckets
const listPromise = await clientS3.listBuckets().promise();
let buckets = listPromse.Buckets;
console.log(buckets);


// Handle promise output
const printBucket = function(lsProm) {
    lsProm.then(function(data) {
        
        // Print JSON String
        let output = JSON.stringify(data.Buckets);
        console.log(output);
    }, function(err) {
        let output = JSON.stringify({'Error': err});
        console.log(output);
    });
}


// Run
printBucket(listPromise(clientS3));