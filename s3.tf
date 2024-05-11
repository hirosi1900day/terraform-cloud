# resource "aws_s3_bucket" "example" {
#   bucket = "cdacdscsacsacdcsdmy-tf-example-bucket"
# }

# resource "aws_s3_bucket_ownership_controls" "example" {
#   bucket = aws_s3_bucket.example.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "example" {
#   depends_on = [aws_s3_bucket_ownership_controls.example]

#   bucket = aws_s3_bucket.example.id
#   acl    = "private"
# }

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "cdacdscsacsacdcsdmy-tf-example-bucket"
  acl    = "private"
  attach_public_policy = false

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"
}
