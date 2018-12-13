terraform {
  backend "s3" {
    bucket = "cleverage-terraform-states"
    key    = "terraform-training"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "~> 1.50"
}

resource "aws_default_vpc" "default" {}

resource "aws_key_pair" "authorized_key" {
  key_name   = "terraform-demo"
  public_key = "${var.authorized_key}"
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

  owners = ["099720109477"]
}

resource "aws_instance" "web" {
  count         = "${var.instances_count}"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instances_type}"
  key_name      = "${aws_key_pair.authorized_key.key_name}"
  tags          = "${var.tags}"
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_default_vpc.default.default_security_group_id}"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  vpc_id      = "${aws_default_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "lb" {
  name               = "terraform-demo-elb"
  instances          = ["${aws_instance.web.*.id}"]
  availability_zones = ["${aws_instance.web.*.availability_zone}"]
  security_groups    = ["${aws_default_vpc.default.default_security_group_id}", "${aws_security_group.allow_http.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  tags = "${var.tags}"
}

resource "ansible_host" "default" {
  count = "${aws_instance.web.count}"
  inventory_hostname = "${aws_instance.web.*.id[count.index]}"
  vars {
    ansible_user = "ubuntu"
    ansible_host = "${aws_instance.web.*.public_ip[count.index]}"
  }
}
