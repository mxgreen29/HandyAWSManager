resource "aws_security_group" "mysql-access" {
  name        = "MySQL SG access"
  description = "MySQL SG"
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sgr
    self        = false
    description = "allow egress all"
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.primary.cidr_block]
    description = "allow all tcp in vpc"
  }
  vpc_id = data.aws_vpc.primary.id
}