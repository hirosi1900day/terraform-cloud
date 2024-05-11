# resource "aws_s3_bucket" "example" {
#   bucket = "hirosi1900dayhogehoge"

#   tags = {
#     Name        = "test"
#     Environment = "Dev"
#   }
# }
/* cloudfrontのログ保管用 */
data "aws_canonical_user_id" "self" {}

resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = "hogegretgeegae-cloudfront-logs"

  tags = {
    Name        = "hogegretgeegae-cloudfront-logs"
    Environment = "test"
  }
}

data "aws_iam_policy_document" "cloudfront_logs" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = ["*"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:PutBucketAcl",
    ]

    resources = ["arn:aws:s3:::hogegretgeegae-cloudfront-logs"]
  }
}

resource "aws_s3_bucket_policy" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_logs.id
  policy = data.aws_iam_policy_document.cloudfront_logs.json
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

resource "aws_s3_bucket_acl" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_logs.id
  access_control_policy {
    /* CloudFrontからログを保存するため、awslogsdeliveryのアカウントIDを許可する */
     grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "READ_ACP"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "WRITE"
    }


    owner {
      id = data.aws_canonical_user_id.self.id
    }
  }
}

/* LBのログ保管用 */
resource "aws_s3_bucket" "lb_logs" {
  bucket = "hogegretgeegae-lb-logs"

  tags = {
    Name        = "hogegretgeegae-lb-logs"
    Environment = "test"
  }
}

# LB のアクセスログを保存するための S3 バケットのポリシー
data "aws_iam_policy_document" "lb_logs" {
  # get, putしか与えない
  statement {
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        # https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/classic/enable-access-logs.html
        "*", # ap-northeast-1
      ]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = ["arn:aws:s3:::hogegretgeegae-lb-logs/*"]
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

resource "aws_s3_bucket_acl" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  access_control_policy {
    /* ALBからログを保存するため、awslogsdeliveryのアカウントIDを許可する */
    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "READ_ACP"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "WRITE"
    }

    owner {
      id = data.aws_canonical_user_id.self.id
    }
  }
}

resource "aws_s3_bucket" "rawlog" {
  bucket = "hogegretgeegae-rawlog"

  tags = {
    Name = "rawlog"
  }
}
