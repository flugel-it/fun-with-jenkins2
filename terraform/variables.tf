
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
