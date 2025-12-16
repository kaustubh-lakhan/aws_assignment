variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of Public Subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security Group ID for the ALB"
  type        = string
}

variable "domain_name" {
  description = "The base domain name for host-based routing (e.g., example.com)"
  type        = string
}

# ACM Certificate ARN is found by the data source, but we still need the domain for the data source
# variable "certificate_arn" {
#   description = "ARN of the ISSUED ACM certificate"
#   type        = string
# }