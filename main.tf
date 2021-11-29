/**
  * Terraform Module to set up Asustor S3 Cloud Sync.
  * 
  * - Creates IAM policy, IAM group and IAM user.
  * - Creates access key and secret for the IAM user.
  * - Creates S3 bucket.
  *   - Bucket policy denies non-private uploads.
  *   - Bucket is versioned.
  *   - Assuming Asustor will use Glacier for uploads - bucket lifecycle rule will move non current versions to Deep Archive and eventually completely expire them.
  */