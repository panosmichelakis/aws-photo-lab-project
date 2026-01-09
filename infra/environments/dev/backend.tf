terraform {
  backend "s3" {
    bucket         = "aws-photo-lab-dev-396913720850-tfstate"
    key            = "environments/dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "aws-photo-lab-dev-tflock"
    encrypt        = true
  }
}
