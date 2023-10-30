resource "aws_security_group" "base" {
  name        = "Public SG"
  description = "Public SG"
  # Outbound HTTPS
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sgr
    description = "allow https because this vpc is public"
  }

  # Outbound HTTP
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sgr
    description = "allow https because this vpc is public"
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.primary.cidr_block]
    description = "allow all tcp for vpc"
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = [data.aws_vpc.primary.cidr_block]
    description = "allow all udp for vpc"
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sgr
    self        = false
    description = "allow all egress"
  }

  ingress {
    from_port = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sgr
    to_port   = 80
    description = "allow http for all world cause this public vpc"
  }
  ingress {
    from_port = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sgr
    to_port   = 443
    description = "allow https for all world cause this public vpc"
  }
  # Allow inbound SSH
  #tfsec:ignore:aws-vpc-no-public-ingress-sgr
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow ssh for all"
    self        = false
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.primary.cidr_block]
    description = "allow all tcp in vpc"
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = [data.aws_vpc.primary.cidr_block]
    description = "allow all udp in vpc"
  }

  vpc_id = data.aws_vpc.primary.id

}
