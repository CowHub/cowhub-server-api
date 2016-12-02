require 'aws-sdk'

Aws.config.update(
  region: 'eu-west-1'
)

access_configuration = {}
if ENV['RAILS_ENV'] == 'production'
  access_configuration = {
    access_key_id: ENV['AWS_ACCESS_KEY'],
    secret_access_key: ENV['AWS_SECRET_KEY']
  }
else
  access_configuration = {
    access_key_id: 'key',
    secret_access_key: 'secret',
    endpoint: 'http://s3:10001',
    force_path_style: true
  }
end

$s3 = Aws::S3::Client.new(access_configuration)
