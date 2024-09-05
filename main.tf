resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-0cffb3a7f5c9240cd"  # Ensure this is the correct VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows SSH from anywhere; restrict this for better security
  }

   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


resource "aws_vpc" "existing-vpc" {
  cidr_block = "10.0.0.0/16"
  tags= {
    name="existing-vpc"
    }
}

import {
  id="vpc-0b9e4065685462b15"
  to= aws_vpc.existing-vpc
}



module "vpc" {
  source = "./modules/"  # Path to the module directory
  cidr_block        = "10.0.0.0/16"
  vpc_name          = "my-sample-template-vpc"
}