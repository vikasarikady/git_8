terraform {
  backend "s3" {
    bucket = "s3.breakingbad.online"
    key    = "git_4/terraform.tfstate"
    region = "ap-south-1"
  }
}
