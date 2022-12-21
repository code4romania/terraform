resource "aws_s3_bucket" "files" {
  bucket = local.domain_name
}

resource "aws_s3_bucket_acl" "media_acl" {
  bucket = aws_s3_bucket.files.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "media_public_access_block" {
  bucket = aws_s3_bucket.files.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket = aws_s3_bucket.files.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.files.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.files.arn}/*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.distribution.iam_arn
      ]
    }
  }
}

# resource "aws_s3_bucket_website_configuration" "s3_bucket" {
#   bucket = aws_s3_bucket.files.id

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }
# }
