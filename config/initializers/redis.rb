require 'redis'

if (ENV['RAILS_ENV'] == 'production')
  params = {host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], password: ENV['REDIS_PASSWORD']}
else
  params = {host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT']}  
end
redis = Redis.new(params)

redis.subscribe('match_result_#{Rails.application.config.server_id}') do |on|
  on.message do |channel, message|
    return unless channel == 'match_result_#{Rails.application.config.server_id}'
    response = JSON.parse(message)
    match = Match.find_by(id: response.request_id)
    return unless match
    if response.diff < ENV['DIFF_TRESHOLD']
      match.update_attribute(status: 'not_found')
    else
      match.update_attribute(status: 'found')
      match.update_attribute(cattle_id: response.cattle_id)
    end
  end
end
