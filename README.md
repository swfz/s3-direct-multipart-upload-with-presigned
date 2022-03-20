# s3-presigned-post-sample

S3のMutipart Uploadをpresigned url を使ってアップロード自体はサーバを経由せずS3へアップロードするためのサンプル

サンプルはファイル選択したらすぐにアップロードされる

他動作条件は下記も参照のこと

https://aws.amazon.com/jp/premiumsupport/knowledge-center/s3-troubleshoot-403/

## IAMユーザーの権限

- 例

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:AbortMultipartUpload",
                "s3:ListBucket",
                "s3:DeleteObject",
                "s3:PutObjectAcl",
                "s3:ListMultipartUploadParts",
                "s3:ListBucketMultipartUploads"
            ],
            "Resource": "arn:aws:s3:::sample-bucket-name/*"
        }
    ]
}
```

## 対象バケットのCORS

下記は1例だがレスポンスヘッダーに`ETag`を含める必要がある

```json
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET",
            "PUT",
            "POST",
            "HEAD"
        ],
        "AllowedOrigins": [
            "*"
        ],
        "ExposeHeaders": [
            "Content-Disposition",
            "ETag"
        ],
        "MaxAgeSeconds": 3000
    }
]
```

## server

```
export AWS_ACCESS_KEY_ID=xxxxx
export AWS_SECRET_ACCESS_KEY=xxxxx
export AWS_BUCKET=xxxxx
export AWS_REGION=ap-northeast-1
bundle isntall
bundle exec rackup --host 0.0.0.0 rack.ru
```

