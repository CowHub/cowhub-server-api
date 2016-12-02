require 'bunny'

bunny = Bunny.new(host: ENV['RABBIT_HOST'], port: ENV['RABBIT_PORT']).start
channel = bunny.create_channel

Rails.application.config.task_queue = channel.queue('task_queue', durable: true)
