module "firehose-ecs-logs" {
  source  = "app.terraform.io/test-horosi1900day/firehose-ecs-logs/kinesis"
  version = "0.0.2"
  # insert required variables here

  s3_bucket = aws_s3_bucket.example
}