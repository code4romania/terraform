resource "aws_cloudfront_distribution" "distribution" {
  comment             = "covid19-stirioficiale static site archive"
  price_class         = "PriceClass_100"
  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2and3"
  default_root_object = "index.html"

  aliases = [local.domain_name]

  origin {
    domain_name = aws_s3_bucket.files.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.files.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.distribution.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    viewer_protocol_policy   = "redirect-to-https"
    target_origin_id         = aws_s3_bucket.files.id
    cache_policy_id          = aws_cloudfront_cache_policy.distribution_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.distribution_origin_request_policy.id
    compress                 = true

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.rewrite.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 404
    response_page_path = "/error.html"
  }
}

resource "aws_cloudfront_origin_access_identity" "distribution" {
  comment = "access-identity-${local.namespace}.s3.amazonaws.com"
}

resource "aws_cloudfront_cache_policy" "distribution_cache_policy" {
  name        = "${local.namespace}-cache"
  min_ttl     = 0
  default_ttl = 86400
  max_ttl     = 2628000

  parameters_in_cache_key_and_forwarded_to_origin {

    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "distribution_origin_request_policy" {
  name = "${local.namespace}-request"

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = "none"
  }

  query_strings_config {
    query_string_behavior = "none"
  }
}

resource "aws_cloudfront_function" "rewrite" {
  name    = "${local.namespace}_rewrite"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/functions/rewrite.js")
}
