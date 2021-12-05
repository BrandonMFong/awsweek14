# EC2
/* resource "aws_instance" "week14-bastion-vm" {
  ami           = "ami-02e136e904f3da870"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.week14-sub-b.id

  vpc_security_group_ids = [
    aws_security_group.week14-ssh-sg-v2.id
  ]

  key_name = "ECE592"

  tags = {
    Name = "week14-bastion-vm"
  }
}*/

## IAM profile ref
#resource "aws_iam_instance_profile" "week14-profile-ref" {
#  name = "week14-profile-ref"
#  role = aws_iam_role.week14-role.name
#  tags = {
#    Name = "week14-profile-ref"
#  }
#}

