terraform {
  backend "s3" {
    bucket         = "java-test-125"  # Update with your desired S3 bucket name
    key            = "javaterraform.tfstate"
    region         = "ap-south-1"  # Update with your AWS region
  
  }
}
