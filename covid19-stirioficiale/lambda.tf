# resource "aws_lambda_function" "rewrite" {
#   function_name = "${local.namespace}_rewrite"
#   filename      = data.archive_file.lambda_rewrite.output_path
#   role          = aws_iam_role.iam_for_lambda.arn
#   handler       = "index.handler"
#   runtime       = "nodejs16.x"
# }

# resource "aws_iam_role" "iam_for_lambda" {
#   name               = "iam_for_lambda"
#   assume_role_policy = data.aws_iam_policy_document.lambda_role_policy.json
# }

# data "aws_iam_policy_document" "lambda_role_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }
#   }
# }

# data "archive_file" "lambda_rewrite" {
#   type        = "zip"
#   source_dir  = "${path.module}/lambda/rewrite"
#   output_path = "${path.module}/lambda/rewrite.zip"
# }
