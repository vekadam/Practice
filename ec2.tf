provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-west-2"
  alias = "west"
}

variable "type" {
  
}

resource "aws_instance" "web" {
  provider = aws.west
  ami = "ami-002829755fa238bfa"
  instance_type = var.type
}