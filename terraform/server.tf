# server.tf

provider "aws" {
  access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
	region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
	cidr_block = "172.15.0.0/16"
}

resource "aws_internet_gateway" "default" {
	vpc_id = "${aws_vpc.default.id}"
}

resource "aws_subnet" "eu-central-1a-public" {
	vpc_id = "${aws_vpc.default.id}"

	cidr_block = "172.15.0.0/24"
	availability_zone = "eu-central-1a"
}

resource "aws_route_table" "eu-central-1-public" {
	vpc_id = "${aws_vpc.default.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.default.id}"
	}
}

resource "aws_security_group" "default" {
	vpc_id = "${aws_vpc.default.id}"
	name = "sg_${var.environment}"
  # SSH and HTTP access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${0.0.0.0/0}"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${0.0.0.0/0}"]
  }

  # outbound internet access
	egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
	
	# NAT
	ingress {
		from_port = 0
		to_port = 65535
		protocol = "tcp"
		cidr_blocks = ["${aws_subnet.eu-central-1a-private.cidr_block}"]
	}
	ingress {
		from_port = 0
		to_port = 65535
		protocol = "tcp"
		cidr_blocks = ["${aws_subnet.eu-central-1a-private.cidr_block}"]
	}
	
	tags {
		Name = "sg-${var.environment}"
	}
}

data "aws_ami" "ubuntu" {
	most_recent = true
	filter {
		name   = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
	}
	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	}
	owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "auth-key" {
	key_name = "${var.environment}-key"
	public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "web" {
	ami = "${data.aws_ami.ubuntu.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
	subnet_id = "${aws_subnet.eu-central-1a-public.id}"
	instance_type = "${var.app_instance_type}"
	availability_zone = "eu-central-1a"
	associate_public_ip_address = true
	key_name = "${aws_key_pair.auth-key.key_name}"
	tags {
		Name = "${var.environment}"
	}
	provisioner "local-exec" {
		command = "sleep 30 && cd .. && echo -e \"[webserver]\n${aws_instance.web.public_ip} ansible_connection=ssh ansible_ssh_user=ubuntu\n\" > inventory &&  ansible-playbook -s -i inventory main.yml"
	}
}

resource "aws_eip" "web" {
	instance = "${aws_instance.web.id}"
	vpc = true
}
