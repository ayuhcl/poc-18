resource "aws_db_subnet_group" "db_subnet_group" {
  name = "poc18-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

resource "aws_db_instance" "postgres" {
  identifier = "poc18-postgres"

  engine         = "postgres"
  engine_version = "17.4"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  username = "adminuser"
  password = "Password123!"

  db_name = "postgres"

  publicly_accessible = false

  vpc_security_group_ids = [
    aws_security_group.aurora_sg.id
  ]

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  skip_final_snapshot = true
}
