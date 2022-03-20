# s3-presigned-post-sample

presigned url を使ってS3へ直接アップロードするためのサンプル

サンプルはファイル選択したらすぐにアップロードされる

他動作条件は下記も参照のこと

https://aws.amazon.com/jp/premiumsupport/knowledge-center/s3-troubleshoot-403/

## IAMユーザーの権限

必要権限は下記

```
"s3:PutObject",
"s3:GetObject",
"s3:DeleteObject",
"s3:PutObjectAcl"
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

