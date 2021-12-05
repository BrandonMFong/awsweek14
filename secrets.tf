resource "aws_secretsmanager_secret" "week14-secret" {
  name = "week14-secret"
}

resource "aws_secretsmanager_secret_version" "week14-secret" {
  secret_id     = aws_secretsmanager_secret.week14-secret.id
  secret_string = jsonencode(local.week14-secret)
}

locals {
  week14-secret = {
    username = aws_rds_cluster.week14-rds.master_username
    password = aws_rds_cluster.week14-rds.master_password
    db = aws_rds_cluster.week14-rds.endpoint
  }
}
