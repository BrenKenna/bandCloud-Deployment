##################################
# 
# Image & EBS volume for servers
# 
##################################

# EBS volume
resource "aws_ebs_volume" "ebs-irl-1a" {
  availability_zone = "eu-west-1a"
  size = 8
  tags = {
    Name = "IRL-1a"
  }
}

# Snapshot for volume
resource "aws_ebs_snapshot" "ebs-irl-1a-Snapshot" {
  volume_id = aws_ebs_volume.ebs-irl-1a.id
  tags = {
    Name = "IRL-1a-SnapShot"
  }
}


# AMI for az-1
resource "aws_ami" "terraform-example-1a" {
  name = "terraform-example-1a"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"

  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = aws_ebs_snapshot.ebs-irl-1a-Snapshot.id
    volume_size = 8
  }

  tags = {
    Name = "terraform-example-1a"
  }
}

##############################
#
# AMI Image for AZ-2
#
##############################

# EBS for AZ-2
resource "aws_ebs_volume" "ebs-irl-1b" {
  availability_zone = "eu-west-1b"
  size = 8
  tags = {
    Name = "IRL-1b"
  }
}

# Snapshot for ebs volume
resource "aws_ebs_snapshot" "ebs-irl-1b-Snapshot" {
  volume_id = aws_ebs_volume.ebs-irl-1b.id
  tags = {
    Name = "IRL-1b-SnapShot"
  }
}

# AMI for AZ-2
resource "aws_ami" "terraform-example-1b" {
  name = "terraform-example-1b"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"

  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = aws_ebs_snapshot.ebs-irl-1a-Snapshot.id
    volume_size = 8
  }
  tags = {
    Name = "terraform-example-1b"
  }
}
