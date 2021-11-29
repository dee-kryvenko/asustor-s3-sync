Terraform Module to set up Asustor S3 Cloud Sync.

- Creates IAM policy, IAM group and IAM user.
- Creates access key and secret for the IAM user.
- Creates S3 bucket.
  - Bucket policy denies non-private uploads.
  - Bucket is versioned.
  - Assuming Asustor will use Glacier for uploads - bucket lifecycle rule will move non current versions to Deep Archive and eventually completely expire them.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.67 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.67.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.asustor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_group.asustor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_policy_attachment.asustor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.asustor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.asustor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.asustor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership) | resource |
| [aws_s3_bucket.sync](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.sync](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [random_string.group_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.user_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [template_file.iam_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.sync_bucket_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_iam_pgp_key"></a> [iam\_pgp\_key](#input\_iam\_pgp\_key) | See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key#pgp_key. If `null` - will not encrypt the resulting secret. | `string` | `null` | no |
| <a name="input_noncurrent_version_expiration_days"></a> [noncurrent\_version\_expiration\_days](#input\_noncurrent\_version\_expiration\_days) | Minimum storage duration charge for Deep Archive is 180 days. Completely deletes old versions of files (including deleted files) after X days. | `number` | `180` | no |
| <a name="input_noncurrent_version_transition_days"></a> [noncurrent\_version\_transition\_days](#input\_noncurrent\_version\_transition\_days) | Assuming Asustor uploads to Glacier - minimum storage duration charge for it is 90 days. Moves old versions of files (including deleted files) after X days to a cheaper storage class. | `number` | `90` | no |
| <a name="input_noncurrent_version_transition_storage_class"></a> [noncurrent\_version\_transition\_storage\_class](#input\_noncurrent\_version\_transition\_storage\_class) | Assuming Asustor uploads to Glacier - moves old versions of files (including deleted files) to Deep Archive. | `string` | `"DEEP_ARCHIVE"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key"></a> [access\_key](#output\_access\_key) | IAM User Access Key |
| <a name="output_access_key_secret"></a> [access\_key\_secret](#output\_access\_key\_secret) | IAM User Access Key Secret (encrypted if iam\_pgp\_key was set) |
| <a name="output_bucket"></a> [bucket](#output\_bucket) | Bucket name |
