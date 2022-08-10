const getInfo = function (aws, region) {
    // EC2 client
    let request = new aws.EC2({apiVersion: '2014-10-01', 'region': region}).describeInstances();

    // create the promise object
    let promise = request.promise();

    // handle promise's fulfilled/rejected states
    promise.then(
        function(data) {
                let ec2_data = data.Reservations[0].Instances[0];
                let output = {
                    'InstanceId': ec2_data.InstanceId,
                    'AMI-ID': ec2_data.ImageId,
                    'AvailZone': ec2_data.Placement.AvailabilityZone,
                    'VpcId': ec2_data.VpcId,
                    'Hypervisor': ec2_data.Hypervisor,
                    'CPU-Count': ec2_data.CpuOptions.CoreCount,
                    'ThreadsPerCore': ec2_data.CpuOptions.ThreadsPerCore
                };
                data = output;
        },
        function(error) {
            let output = {"Error": error.stack};
            console.log(output);
        }
    );

    // Return promise
    return promise;
}


// Function to parse ec2 data dict
const parseInfo = function (dataDict) {
    let ec2_data = dataDict.Reservations[0].Instances[0];
    let output = {
        'InstanceId': ec2_data.InstanceId,
        'AMI-ID': ec2_data.ImageId,
        'AvailZone': ec2_data.Placement.AvailabilityZone,
        'VpcId': ec2_data.VpcId,
        'Hypervisor': ec2_data.Hypervisor,
        'CPU-Count': ec2_data.CpuOptions.CoreCount,
        'ThreadsPerCore': ec2_data.CpuOptions.ThreadsPerCore
    };
    return output;
}

module.exports = {getInfo, parseInfo};