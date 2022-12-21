terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.35"
    }
  }
}

provider "aws" {
  region  = local.region
  profile = "taskforce"

  default_tags {
    tags = {
      app       = "stirioficiale"
      env       = "production"
      taskforce = "covid19"
    }
  }
}


provider "aws" {
  alias = "global"

  region  = "us-east-1"
  profile = "taskforce"

  default_tags {
    tags = {
      app       = "stirioficiale"
      env       = "production"
      taskforce = "covid19"
    }
  }
}
