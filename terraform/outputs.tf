output "ecr_repository_url" {
  value = aws_ecr_repository.website_repo.repository_url
}
output "aurora_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}
output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
