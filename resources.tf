resource "aws_key_pair" "auth_key" {
  key_name   = "${var.project_name}-${var.project_env}"
  public_key = file("auth_key.pub")
  tags = {
    Name = "${var.project_name}-${var.project_env}"
  }
}

resource "aws_security_group" "frontend_access" {
  name = "${var.project_name}-${var.project_env}-frontend_access"

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.project_env}-frontend_access"
  }
}

resource "aws_security_group" "remote_access" {
  name = "${var.project_name}-${var.project_env}-remote_access"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.project_env}-remote_access"
  }
}

resource "aws_instance" "webserver" {
  ami                    = var.ami_id
  instance_type          = var.type
  key_name               = aws_key_pair.auth_key.key_name
  user_data              = file("userdata.sh")
  vpc_security_group_ids = [aws_security_group.frontend_access.id, aws_security_group.remote_access.id]
  tags = {
    Name = "${var.project_name}-${var.project_env}-webserver"
  } 
}

resource "aws_eip" "webserver" {
  instance = aws_instance.webserver.id
  domain   = "vpc"
  tags = {
    Name = "${var.project_name}-${var.project_env}-webserver"
  }         
}

resource "aws_route53_record" "hostname" {

  zone_id = data.aws_route53_zone.rootdomain.id
  name    = "${var.hostname}.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.webserver.public_ip]
}
