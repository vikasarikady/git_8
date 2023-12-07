variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "project_env" {
  type        = string
  description = "Project Environment"
}

variable "project_owner" {
  type        = string
  description = "Owner of the project"
}

variable "region" {
  type        = string
  description = "Region"
}

variable "ami_id" {
  type        = string
  description = "AMI ID"
}

variable "type" {
  type        = string
  description = "instance type"
}
