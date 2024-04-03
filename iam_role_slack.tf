data "aws_cloudwatch_log_group" "slack-aws-handler" {
  name = "/aws/lambda/aws-slack"
}

data "aws_sqs_queue" "slack-aws" {
  name = "test-aws.fifo"
}

data "aws_iam_policy_document" "assume_slack" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "slack" {
  # AWS Account intra の slack_role から各 AWS Account へスイッチする権限
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:GetAccessKeyInfo",
      "sts:GetCallerIdentity",
      "sts:GetSessionToken",
    ]
    resources = ["*"] # trivy:ignore:AWS099
  }

  # 個々のユーザのスイッチ可能なロール一覧を取得する際に必要な権限
  statement {
    actions = [
      "iam:ListUserPolicies",
      "iam:GetUserPolicy",
    ]
    resources = ["*"] # trivy:ignore:AWS099
  }

  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:GetQueueAttributes",
      "sqs:DeleteMessage",
    ]
    resources = [data.aws_sqs_queue.slack-aws.arn]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [data.aws_cloudwatch_log_group.slack-aws-handler.arn]
  }
}

resource "aws_iam_role" "slack_role" {
  name               = "slack_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_slack.json
}

resource "aws_iam_role_policy" "slack_policy" {
  name   = "slack_policy"
  role   = aws_iam_role.slack_role.id
  policy = data.aws_iam_policy_document.slack.json
}

output "slack_role_arn" {
  value = aws_iam_role.slack_role.arn
}