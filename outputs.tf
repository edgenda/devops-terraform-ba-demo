output "elb_dns_name" {
  value = "${aws_elb.lb.dns_name}"
}