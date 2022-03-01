/**
 * Overview:
 * 
 *      => Constructed with basic details
 *      => ec2 is a property
 *      => Getting the preferred details is a method
 * 
 * - Import AWS-SDK instead of require
 *    -> Trying out passing an AWS instance to this object
 * 
 */

// Class for common ec2 interactions
class EC2_VM {

    // Constructor
    constructor(AWS, region) {

        // Common things to query
        let params =  { 
            InstanceIds: ['INSTANCE_ID'],
            DryRun: false
        }

        // EC2-client
        this.ec2 = new AWS.EC2({'region': region});
    }

    // Fetch instance details
    getInfo() {
        
        // Initalize holder & output
        let ec2_data, output;

        // Return promise for getting instance details
        let outPromise = new Promise( function(resolve, reject) {

          // Get instance details
          let request = this.ec2.describeInstances();
          let ec2_promise = request.promise();
          
          // Resolve promise with error if failed
          ec2_promise.then(
              function(data) {
                // Parse results
                ec2_data = data.Reservations[0].Instances[0];
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

                // Return results from EC2-Describe
                console.log('Hello');
                resolve(output);
              }, function(error) {
                output = {"Error": error.stack};
                reject(output);
              }
          );
  
          });

        // Return promise
        return outPromise
    }
}

// Export class
module.exports = EC2_VM;