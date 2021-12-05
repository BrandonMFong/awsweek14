resource "aws_db_subnet_group" "week14-db-subnet-group" {
  name       = "week14-db-subnet-group"
  subnet_ids = [aws_subnet.week14-pri-a.id, aws_subnet.week14-pri-b.id]

  tags = {
    Name = "week14 db subnet"
  }
}

# Cluster
resource "aws_rds_cluster" "week14-rds" {
  cluster_identifier      = "week14-rds"
  engine                  = "aurora-mysql"
  engine_mode 		  = "serverless"
  #engine_version          = "5.7.mysql_aurora.2.03.2"
  availability_zones      = ["us-east-1a"]
  database_name           = "week14_rds"
  master_username         = "admin"
  master_password         = "secret123"
  #backup_retention_period = 5
  #preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true 
  db_subnet_group_name    = aws_db_subnet_group.week14-db-subnet-group.name
  vpc_security_group_ids  = [aws_security_group.week14-rds-sg.id]
  
  scaling_configuration {
    auto_pause               = true
    max_capacity             = 2
    min_capacity             = 1
    seconds_until_auto_pause = 300
#    timeout_action           = "ForceApplyCapacityChange"
  }
}

