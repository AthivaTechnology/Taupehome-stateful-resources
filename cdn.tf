# Create a new Origin Access Identity (OAI) for CloudFront
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "New OAI for json file"
}

# Configure CloudFront distribution
resource "aws_cloudfront_distribution" "static_website_distribution" {
  aliases                        = [
        "liberty.cdn.lhgcts.com",
        "www.liberty.cdn.lhgcts.com",
    ]
  origin {
    domain_name = "${local.hosting_bucket_id}.s3.us-west-2.amazonaws.com"
    origin_id   = "${local.hosting_bucket_id}.s3.us-west-2.amazonaws.com"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Json file Distribution via CloudFront"
  default_root_object = local.swap_object

  default_cache_behavior {
    target_origin_id = "${local.hosting_bucket_id}.s3.us-west-2.amazonaws.com"

    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
     acm_certificate_arn            = local.cdn_cert_arn
     cloudfront_default_certificate = false
     minimum_protocol_version       = "TLSv1.2_2021"
     ssl_support_method             = "sni-only"
    
  }

  logging_config {
    include_cookies  = true
    prefix           = "liberty/distribution-logs/" 
    bucket           = "${local.hosting_bucket_id}.s3.amazonaws.com"
  }  
  
  
}

# Update the S3 bucket policy to allow access from the CloudFront OAI
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = local.hosting_bucket_id
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "PolicyForCloudFrontPrivateAccess",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        
        },
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${local.hosting_bucket_id}/*",
      },
    ],
  })
}


