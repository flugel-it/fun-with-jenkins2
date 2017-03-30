# server.tf

provider "aws" {
  access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
	region = "${var.aws_region}"
}

resource "aws_security_group" "default" {
	vpc_id = "${var.vpc_id}"
	name = "sg_${var.environment}"
  # HTTP access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.allowed_ip}"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${var.allowed_ip}"]
  }

  # outbound internet access
  egress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${var.allowed_ip}"]
  }
	egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
	subnet_id = "${var.subnet_id}"
	instance_type = "${var.app_instance_type}"
	key_name = "${aws_key_pair.auth-key.key_name}"
	tags {
		Name = "${var.environment}"
	}
	provisioner "local-exec" {
		command = "sleep 30 && cd .. && echo -e \"[webserver]\n${aws_instance.web.public_ip} ansible_connection=ssh ansible_ssh_user=ubuntu\n\" > inventory &&  ansible-playbook -s -i inventory main.yml"
	}
}

