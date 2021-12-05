# Security Group
resource "aws_security_group" "week14-https-sg" {
  name        = "week14-https-sg"
  description = "Week10 endpoints tf"
  vpc_id      = aws_vpc.week14-vpc.id

  ingress = [{
    description = "SSH from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.week14-vpc.cidr_block]

    # Suggested by professor
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = [aws_security_group.week14-ssh-sg-v2.id]
    self             = false
  }]

  egress = [{
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    # Suggested
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  tags = {
    Name = "week14-ssh-pri-sg"
  }
}

# EC2
resource "aws_vpc_endpoint" "week14-sm-ep" {
  vpc_id            = aws_vpc.week14-vpc.id
  service_name      = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.week14-pri-a.id, aws_subnet.week14-pri-b.id]

  security_group_ids = [
    aws_security_group.week14-https-sg.id,
  ]

  private_dns_enabled = true

  tags = {
    Environment = "EC2 Endpoint"
  }
}

