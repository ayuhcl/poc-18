resource "aws_db_subnet_group" "aurora_subnet_group" {
  name = "aurora-subnet-group-ayushi"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "poc18-aurora"

  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.05.2"

  master_username = "adminuser"
  master_password = "Password123!"

  db_subnet_group_name   = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]

  skip_final_snapshot = true
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier         = "poc18-aurora-instance"
  cluster_identifier = aws_rds_cluster.aurora.id

  instance_class = "db.t3.medium"
  engine         = aws_rds_cluster.aurora.engine
}

