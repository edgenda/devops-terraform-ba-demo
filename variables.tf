variable "aws_region" {
  type = "string"
  description = "The AWS region to use"
  default = "us-east-1"
}

variable "authorized_key" {
  type = "string"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwsC7lXpAzfTrFhQIpBnTh2HJWypuCJtgLdzFc/hQ6XIaKGuZVXV7a25Pz0nMesYRwrJkXXYsU0cILfM/KxoQ1Y24RjZlkoaBGvcVoMv16NwCtKkMh3eQYvkIq1RVNk+75aV4PLa3y4/wqx+jwNPUJODl6yHgH2pRkEMpfF5g20oMTiyePSqcjyumxHItOY4ieMsuHUfAGJ/psmM4++lzsSemmMNuKitrVU7Ftp0Nc3Wt/LAxDC0AKfTLWSyn5M4f/tzdiHJrPjCcaSBBy/kxZcrXGTQrpM2JS6STo50f7kHWWrTL88EnYbo3V027Q41zseNiXQz0QjPzTekjONY7J bargenson@Brices-MacBook-Pro.local"
}

variable "instances_type" {
  default = "t2.micro"
}

variable "instances_count" {
  default = 1
}

variable "tags" {
  type = "map"
  default = {
    demo = true
  }
}
