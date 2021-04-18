#
# DocRef: https://learn.hashicorp.com/tutorials/terraform/aws-remote?in=terraform/aws-get-started
#
# Important 2 steps:
# 1. Create a CLI-driven Terraform Cloud workspace
# 2. Navigate to the workspace's settings and under general, change the execution mode on the workspace to be "local"
# Then just follow the instructions on the DocRef. The following are FYI key learning points.
# - https://app.terraform.io/ : To login directly 
# - https://app.terraform.io/app/settings/tokens?source=terraform-login : This will prompt to create a token. Cancel is you already have a token
# - Terraform will store the token in plain text in the following file for use by subsequent commands: ~/.terraform.d/credentials.tfrc.json
# - Navigate to the state file to see the state stored @ https://app.terraform.io/app/ORG-NAME/workspaces/WORKSPACE-NAME/states/STATE_FILE-NAME
# - Toekn cleanup: terraform logout [hostname (default app.terraform.io)] will remove credentials stored by terraform login
# - https://www.terraform.io/docs/internals/credentials-helpers.html : Use credentials helpers as an alternative approach to customize credentials using an external program

If you don't provide an explicit hostname, Terraform will assume you want to log out of Terraform Cloud at app.terraform.io

terraform {
  # The block below canbe copied from https://app.terraform.io/app/ORG-NAME/workspaces/WORKSPACE-NAME
  backend "remote" {
    organization = "ORG-NAME"

    workspaces {
      name = "WORKSPACE-NAME"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0742b4e673072066f"
  instance_type = "t2.micro"
}
