provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Name  = var.project_name
      Env   = var.project_env
      Owner = var.project_owner
    }
  }
}

