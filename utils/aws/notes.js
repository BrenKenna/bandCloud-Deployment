/**
 * This should be an object
 *      => Constructed with basic details
 *      => ec2 is a property
 *      => Getting the preferred details is a method
 */

// Import required modules
const AWS = require('aws-sdk');
// AWS.config.loadFromPath('./config.json');

// Class for common ec2 interactions
class ec2_vm {

    // Constructor
    constructor() {

        // Common things to query
        let params =  { 
            InstanceIds: ['INSTANCE_ID'],
            DryRun: false
        }

        // EC2-client
        this.ec2 = new AWS.ec2({'region': 'eu-west-1'});
    }

    // Fetch instance details
    getInfo(){
        
        // Initalize holder & output
        let ec2_data, output;

        // Get instance details
        ec2.describeInstances(params, function(err, data) {
            if (err) {
              console.log("Error", err.stack);
            } else {
                ec2_data = data.Reservations[0].Instances[0];
            }
        });

        // Return results
        output = {
            'InstanceId': ec2_data.InstanceId,
            'AMI-ID': ec2_data.ImageId,
            'AvailZone': ec2_data.Placement.AvailabilityZone,
            'VpcId': ec2_data.VpcId,
            'Hypervisor': ec2_data.Hypervisor,
            'CPU-Count': ec2_data.CpuOptions.CoreCount,
            'ThreadsPerCore': ec2_data.CpuOptions.ThreadsPerCore,
            'MAC-Addr': ec2_data.NetworkInterfaces[0].MacAddress,
            'SG-Id': ec2_data.SecurityGroups[0].GroupName,
        };

        // Return summary
        return output;
    }
}