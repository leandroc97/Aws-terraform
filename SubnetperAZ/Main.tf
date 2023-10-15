/*
Automate the creation of subnets for each AZ in a specific region chosen by the user
The subnet range is increased by +1 on 3rd octet per AZ
*/

data "aws_availability_zones" "AZ" {    # This data source retrieves all AZs in the region that the user defines.
}

resource "aws_vpc" "exampleVPC" {    # creation of the Main VPC for the region
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "subnet" {                                                # creation of the subnet with the terraform name "subnet"
  count             = length(data.aws_availability_zones.AZ.names)              # the count here will create many subnets as the number of AZs available on the region
  vpc_id            = aws_vpc.exampleVPC.id
  cidr_block        = "10.0.${10 + count.index}.0/24"                           # the cidr block increases +1 on the 3rd octet per AZ, the index number starts at 0
  availability_zone = data.aws_availability_zones.AZ.names[count.index]         #count for each of the AZs, the count acts like a for each loop

  tags = {
    Name = "subnet"
  }
}






