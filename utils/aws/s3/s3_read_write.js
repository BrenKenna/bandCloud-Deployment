/**
 * Utility functions for interacting with s3
 *  - Main bucket = bandCloud
 *  - Functions to return promise for set of actions
 *  - Functions to resolve an actions promise
 */

// Importing
const region = 'eu-west-1';
const AWS = require('aws-sdk');
const clientS3 = new AWS.S3({apiVersion: '2014-10-01', 'region': region});


// List buckets
const listPromise = function () {
    return clientS3.listBuckets().promise();
}


// Handle promise output
const printBucket = function(lsProm) {
    lsProm.then(function(data) {
        
        // Print JSON String
        for(i of data.Buckets) {
            console.log(i.Name);
        }
        console.log("\n");
    }, function(err) {
        console.log(err);
        console.log("\n");
    });
}


const bucketList = (clientS3) => {
    const listPromise = await clientS3.listBuckets().promise();
    let buckets = listPromse.Buckets;
    console.log(buckets);
    return buckets
}


// Export
module.exports = {listPromise, printBucket, bucketList};