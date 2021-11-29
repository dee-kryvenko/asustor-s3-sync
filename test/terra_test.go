package test

import (
	"bytes"
	"context"
	"os"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/feature/s3/manager"
	"github.com/aws/aws-sdk-go-v2/service/s3"

	taws "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestModule(t *testing.T) {
	region := os.Getenv("AWS_DEFAULT_REGION")
	require.NotEmpty(t, region)

	terraformOptions := &terraform.Options{
		TerraformDir: "..",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	bucket := terraform.Output(t, terraformOptions, "bucket")
	accessKey := terraform.Output(t, terraformOptions, "access_key")
	accessKeySecret := terraform.Output(t, terraformOptions, "access_key_secret")

	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithCredentialsProvider(
			credentials.NewStaticCredentialsProvider(
				accessKey, accessKeySecret, "")))
	require.NoError(t, err)

	client := s3.NewFromConfig(cfg)

	taws.AssertS3BucketVersioningExists(t, region, bucket)

	_, err = client.ListBuckets(context.TODO(),
		&s3.ListBucketsInput{},
	)
	require.NoError(t, err)

	_, err = client.ListObjects(context.TODO(),
		&s3.ListObjectsInput{
			Bucket: aws.String(bucket),
		},
	)
	require.NoError(t, err)

	_, err = client.PutObject(context.TODO(),
		&s3.PutObjectInput{
			Bucket: aws.String(bucket),
			Key:    aws.String("terratest"),
			Body:   manager.ReadSeekCloser(strings.NewReader("hi")),
			ACL:    "public",
		},
	)
	require.Error(t, err)

	_, err = client.PutObject(context.TODO(),
		&s3.PutObjectInput{
			Bucket: aws.String(bucket),
			Key:    aws.String("terratest"),
			Body:   manager.ReadSeekCloser(strings.NewReader("hi")),
			ACL:    "private",
		},
	)
	require.NoError(t, err)

	rawObject, err := client.GetObject(context.TODO(),
		&s3.GetObjectInput{
			Bucket: aws.String(bucket),
			Key:    aws.String("terratest"),
		},
	)
	buf := new(bytes.Buffer)
	require.NoError(t, err)
	_, err = buf.ReadFrom(rawObject.Body)
	require.NoError(t, err)
	assert.Equal(t, "hi", buf.String())

	_, err = client.DeleteObject(context.TODO(),
		&s3.DeleteObjectInput{
			Bucket: aws.String(bucket),
			Key:    aws.String("terratest"),
		},
	)
	require.NoError(t, err)

	taws.EmptyS3Bucket(t, region, bucket)
}
