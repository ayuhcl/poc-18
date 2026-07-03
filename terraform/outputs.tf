output "ecr_repository_url" {
  value = aws_ecr_repository.website_repo.repository_url
}
output "db_endpoint" {
  value = aws_db_instance.postgres.address
}
output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
