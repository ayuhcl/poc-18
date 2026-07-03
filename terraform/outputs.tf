output "ecr_repository_url" {
  value = aws_ecr_repository.website_repo.repository_url
}
output "aurora_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}
