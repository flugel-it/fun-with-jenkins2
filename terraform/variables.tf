
variable "access_key" {
	description = <<DESC
	The AWS Access Key 
DESC
}

variable "secret_key" {
	description = <<DESC
	The AWS Secret Access Key
DESC
}

variable "environment" {
	description = <<DESC
	The environment name
DESC
}

variable "aws_region" {
	description = <<DESC
	The region of hosting
	Example: "us-east-1"
DESC
}

variable "vpc_id" {
	description = <<DESC
	The id of the VPC that 
	the desired security group belongs to
DESC
}

variable "app_instance_type" {
	description = <<DESC
	The app instance type
	Example: "t2.micro"
DESC
}

variable "public_key_path" {
	description = <<DESC
	The public key for connection
	Example: "~/.ssh/id_rsa.pub"
DESC
}

variable "allowed_ip" {
	description = <<DESC
	The IP for which you allow the connection
DESC
}

variable "subnet_id" {}
