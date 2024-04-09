resource "aws_s3_bucket" "example" {
  bucket = "hirosi1900dayhogehoge"

  tags = {
    Name        = "test"
    Environment = "Dev"
  }
}
