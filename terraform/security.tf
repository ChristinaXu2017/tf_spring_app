# Initialization for the random provider
provider "random" { }

# Generate a random string of length 5
resource "random_string" "example" {
  length  = 5
  special = false
}

######## security group ##################
resource "aws_security_group" "uts_app_sg" {
  description = "Security group to allow SSH/HTTP inbound and all outbound"
  name        = "uts_app_${random_string.example.result}"
  vpc_id      = local.vpc_id
  tags = { Name = "uts_sg" }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_ssh_from_trusted_ip" {
  for_each          = toset(var.ssh_ips)
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.uts_app_sg.id
  lifecycle {
      ignore_changes = [cidr_blocks]
  }
}

resource "aws_security_group_rule" "allow_http_from_trusted_ip" {
  for_each          = toset(var.http_ips)
  type              = "ingress"
  from_port         = 8888
  to_port           = 8888
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.uts_app_sg.id
}

