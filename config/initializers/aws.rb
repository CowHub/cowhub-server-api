if ENV['RAILS_ENV'] == 'production'
  require 'aws-sdk'

  $s3 = Aws::S3::Client.new(
    access_key_id: ENV['AWS_ACCESS_KEY'],
    secret_access_key: ENV['AWS_SECRET_KEY']
  )
end
