require 'bunny'

Rails.application.config do |config|
  config.bunny = Bunny.new(host: ENV['RABBIT_HOST'])
  config.bunny.start

  puts config.bunny
end
