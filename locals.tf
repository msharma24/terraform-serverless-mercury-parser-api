
locals {
  region     = data.aws_region.current.id
  account_id = data.aws_caller_identity.current.account_id
}

