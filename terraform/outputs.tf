output "api_invoke_url" {
  value       = module.app_api.stage_invoke_url
  description = "API URL"
}

output "distribution_url" {
  value       = "https://${aws_cloudfront_distribution.app_distribution.domain_name}"
  description = "FRONTEND URL"
}