variable "aws_region" {
  description = "AWS Region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "The base domain name for host-based routing "
  type        = string
  default     = "lakhan.click" # NOTE: Change this to your actual domain name
}

variable "ecr_repository_url" {
  description = "The ECR repository URL for the microservice image (e.g., 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-repo)"
  type        = string
  default     = "public.ecr.aws/f8k5n6s7/sample-microservice" # Provide a default or placeholder
}