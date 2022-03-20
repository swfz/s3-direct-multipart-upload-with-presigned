#!/usr/bin/env ruby

require 'aws-sdk-s3'

client = Aws::S3::Client.new(region: 'ap-northeast-1', http_wire_trace: true)

# Abort Bucket Owner権限が必要っぽい？ このときはとりあえずS3の管理権限を付けた https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListMultipartUploads.html
uploads = client.list_multipart_uploads(bucket: ENV['AWS_BUCKET'])
uploads.uploads.each {|u| client.abort_multipart_upload(bucket: ENV['AWS_BUCKET'], key: u.key, upload_id: u.upload_id)}
