require 'aws-sdk'

Aws.config.update(
  region: 'eu-west-1'
)

if ENV['RAILS_ENV'] == 'production'
  access_configuration = {
    access_key_id: ENV['AWS_ACCESS_KEY'],
    secret_access_key: ENV['AWS_SECRET_KEY']
  }
else
  access_configuration = {
    access_key_id: 'YOUR_ACCESS_KEY_ID',
    secret_access_key: 'YOUR_SECRET_ACCESS_KEY',
    s3_endpoint: 'localhost',
    s3_port: 10001,
    use_ssl: false
  }
end

$s3 = Aws::S3::Client.new(access_configuration)
