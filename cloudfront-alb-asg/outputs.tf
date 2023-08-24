output "web-address" {
  value = aws_lb.demo-lb.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.demo-asg.name
}

output "cloudfront-dns-name" {
  description = "CloudFront Distribution URL"
  value = aws_cloudfront_distribution.cf_dist.domain_name
}