resource "aws_iam_role" "monitoring_instances" {
  name = "${var.project_tag}-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

}

resource "aws_iam_role_policy" "monitoring_instances" {
  name = "${var.project_tag}-instance-policy"
  role = aws_iam_role.monitoring_instances.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "RacfStateBucketAccess"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.racf_state.arn
        ]
      },
      {
        Sid    = "RacfStateObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.racf_state.arn}/racf/*"
        ]
      },
      {
        Sid    = "ReadMonitoringSsmParameters"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:DescribeParameters"
        ]
        Resource = [
          "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/monitoring/*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "monitoring_instances" {
  name = "${var.project_tag}-instance-profile"
  role = aws_iam_role.monitoring_instances.name
}