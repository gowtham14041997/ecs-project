provider "aws" {
  region     = var.region
}

resource "aws_ecr_repository" "opstree_ecr_repo" {
  count  = 2
  name   = element(var.ecr_repo_name, count.index)
}