variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for both hosts"
  type        = string
}

variable "project_tag" {
  description = "Value for the Project tag on all resources"
  type        = string
}

variable "frontend_role_tag" {
  description = "Value for the Role tag on the frontend EC2 instance"
  type        = string
}

variable "backend_role_tag" {
  description = "Value for the Role tag on the backend EC2 instance"
  type        = string
}
