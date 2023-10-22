provider "aws" {
  region = "eu-north-1"
}

provider "aws" {
  alias = "west"
  region = "eu-west-1"
}