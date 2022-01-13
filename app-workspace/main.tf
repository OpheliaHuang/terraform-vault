
data "terraform_remote_state" "admin" {
  backend = "local"

  config = {
    path = var.path
  }
}

data "vault_aws_access_credentials" "creds" {
  backend = data.terraform_remote_state.admin.outputs.backend
  role    = data.terraform_remote_state.admin.outputs.role
}

provider "aws" {
  region     = var.region
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}

variable "name" { default = "learn" }
variable "region" { default = "eu-west-1" }
variable "path" { default = "../vault-workspace/terraform.tfstate" }

data "aws_vpc" "tut" {
  filter {
    name = "tag:Name"
    values = ["MyVPC"]
  }
}

# resource "aws_subnet" "main" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"

#   tags = {
#     Name  = var.name
#   }
# }

output "my-output" {
  value       = data.aws_vpc.tut
  description = " the ip of the main server instance"
}
