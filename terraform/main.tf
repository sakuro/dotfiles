# dot.2238.club - Dotfiles hosting proxy
#
# Rewrites:
#   /           -> https://raw.githubusercontent.com/sakuro/dotfiles/refs/heads/main/bootstrap.sh
#   /path/file  -> https://raw.githubusercontent.com/sakuro/dotfiles/refs/heads/main/path/file

locals {
  zone_name = "2238.club"
  subdomain = "dot"
  domain    = "${local.subdomain}.${local.zone_name}"
  origin_id = "github-raw"
}

# -----------------------------------------------------------------------------
# ACM Certificate
# -----------------------------------------------------------------------------

resource "aws_acm_certificate" "dot" {
  provider          = aws.us_east_1
  domain_name       = local.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "gandi_livedns_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.dot.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone   = local.zone_name
  name   = trimsuffix(each.value.name, ".${local.zone_name}.")
  type   = each.value.type
  ttl    = 300
  values = [each.value.value]
}

resource "aws_acm_certificate_validation" "dot" {
  provider        = aws.us_east_1
  certificate_arn = aws_acm_certificate.dot.arn

  validation_record_fqdns = [
    for record in gandi_livedns_record.validation : "${record.name}.${local.zone_name}"
  ]
}

# -----------------------------------------------------------------------------
# CloudFront Function for URL rewriting
# -----------------------------------------------------------------------------

resource "aws_cloudfront_function" "rewrite" {
  name    = "dot-2238-club-rewrite"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = <<-EOF
    function handler(event) {
      var request = event.request;
      var uri = request.uri;

      // Rewrite root path to bootstrap.sh
      if (uri === '/' || uri === '') {
        request.uri = '/sakuro/dotfiles/refs/heads/main/bootstrap.sh';
      } else {
        // Prepend the repository path
        request.uri = '/sakuro/dotfiles/refs/heads/main' + uri;
      }

      return request;
    }
  EOF
}

# -----------------------------------------------------------------------------
# CloudFront Distribution
# -----------------------------------------------------------------------------

# Caching is disabled so that a pushed fix is served immediately: this site
# distributes bootstrap.sh, which is piped to a shell.
data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "cors_s3_origin" {
  name = "Managed-CORS-S3Origin"
}

resource "aws_cloudfront_distribution" "dot" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "dot.2238.club - Dotfiles proxy"
  aliases         = [local.domain]

  origin {
    domain_name = "raw.githubusercontent.com"
    origin_id   = local.origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.cors_s3_origin.id

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
    acm_certificate_arn      = aws_acm_certificate_validation.dot.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

resource "gandi_livedns_record" "dot" {
  zone   = local.zone_name
  name   = local.subdomain
  type   = "CNAME"
  ttl    = 3600
  values = ["${aws_cloudfront_distribution.dot.domain_name}."]
}
