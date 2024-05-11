# S3 バケットの定義 (CloudFrontのログ用)
resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = "hogegretgeegae-cloudfront-logs"

  tags = {
    Name        = "hogegretgeegae-cloudfront-logs"
    Environment = "test"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  rule {
    id     = "log_transition"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 1095
      storage_class = "GLACIER"
    }
  }
}

# S3 バケットの定義 (LBのログ用)
resource "aws_s3_bucket" "lb_logs" {
  bucket = "hogegretgeegae-lb-logs"

  tags = {
    Name        = "hogegretgeegae-lb-logs"
    Environment = "test"
  }
}

# LBのアクセスログ用ポリシー
data "aws_iam_policy_document" "lb_logs" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]  # Elastic Load Balancing のログサービス
    }

    actions = [
      "s3:PutObject",
    ]

    resources = ["arn:aws:s3:::hogegretgeegae-lb-logs/*"]  # バケット内のすべてのオブジェクトを指定
  }
}

resource "aws_s3_bucket_policy" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  policy = data.aws_iam_policy_document.lb_logs.json
}

resource "aws_s3_bucket_lifecycle_configuration" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id

  rule {
    id     = "log_transition"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}
