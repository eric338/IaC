locals {
  common_tags = {
    Project     = XXX
    Environment = XXX
  }
}

locals {
  suffix_name = "XXX"
}

resource "aws_instance" "instance_a" {
  ami           = XXX
  instance_type = XXX

  tags = {
    Name = "instance-a-XXX"
  }
}

resource "aws_instance" "instance_b" {
  ami           = XXX
  instance_type = XXX

  tags = {
    Name = "instance-b-XXX"
  }
}

resource "aws_eip" "eip_a" {
  domain   = "vpc"
  instance = XXX

  tags = {
    Name = "elastic-ip-instance-a-XXX"
  }
}

resource "aws_eip" "eip_b" {
  domain   = "vpc"
  instance = XXX

  tags = {
    Name = "elastic-ip-instance-b-XXX"
  }
}

# resource "random_string" "random" {
#   length  = 10
#   special = false
#   lower   = true
#   upper   = false
#   numeric = true
# }

# resource "aws_s3_bucket" "bucket" {
#   bucket = "mybucket-${random_string.random.result}"

#   tags = {
#     Name = "mybucket-${random_string.random.result}"
#   }
# }

# resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
#   bucket = aws_s3_bucket.bucket.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "bucket_acl" {
#   depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
#   bucket     = aws_s3_bucket.bucket.id
#   acl        = "private"
# }

# resource "aws_s3_object" "object" {
#   bucket = aws_s3_bucket.bucket.id
#   key    = "index.html"
#   source = "./index.html"
# }

