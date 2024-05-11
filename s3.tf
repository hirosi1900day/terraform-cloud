# module "s3_bucket" {
#   source = "terraform-aws-modules/s3-bucket/aws"

#   bucket = "cdacdscsacsacdcsdmy-tf-example-bucket"
#   acl    = "private"

#   control_object_ownership = true
#   object_ownership         = "BucketOwnerPreferred"
# }

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "cdcdcddsacdscsacsacdcsdmy-tf-example-bucket"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"
}

# TODO: stateの移行が完了したら削除する
