# encoding: utf-8

require 'aws-sdk-s3'
require 'awesome_print'

class SimpleServer
  def call(env)
    request = Rack::Request.new(env)

    body = request.body.read
    params = body == '' ? nil : JSON.parse(body)

    case request.path
    # index.html
    when '/'
      [
        200,
        {
          'Content-Type'  => 'text/html',
          'Cache-Control' => 'public, max-age=86400'
        },
        File.open('./index.html', File::RDONLY)
      ]
    # マルチパートアップロードの開始
    when '/create_multipart_upload'
      client = Aws::S3::Client.new(region: 'ap-northeast-1')
      key = "multipart_upload/#{params['object_name']}"

      multipart_upload = client.create_multipart_upload(
        bucket: ENV['AWS_BUCKET'],
        key: key
      )

      [
        200,
        { 'Content-Type' => 'application/json' },
        [{ upload_id: multipart_upload.upload_id, object_key: key }.to_json]
      ]
    # presigned URLの発行
    when '/get_presigned_url'
      signer = Aws::S3::Presigner.new
      signed_url = signer.presigned_url(:upload_part,
        {
          bucket: ENV['AWS_BUCKET'],
          key: params['object_key'],
          expires_in: 3600,
          part_number: params['part_number'],
          upload_id: params['upload_id']
        }
      )

      [
        200,
        { 'Content-Type' => 'application/json' },
        [{ url: signed_url }.to_json]
      ]
    # マルチパートアップロードの終了
    when '/complete_multipart_upload'
      client = Aws::S3::Client.new(region: 'ap-northeast-1', http_wire_trace: true)

      parts = {parts: params['parts'].map{|part| {part_number: part['part_number'], etag: part['etag']}}}

      res = client.complete_multipart_upload(
        bucket: ENV['AWS_BUCKET'],
        key: params['object_key'],
        multipart_upload: parts,
        upload_id: params['upload_id'],
      )

      [
        200,
        { 'Content-Type' => 'application/json' },
        [res.to_json]
      ]
    else
      [404, {}, ['Not Found']]
    end
  end
end

run SimpleServer.new
