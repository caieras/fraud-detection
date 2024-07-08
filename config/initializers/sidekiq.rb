require 'sidekiq'
require 'sidekiq/api'

connection_url = "redis://localhost:6379"

Sidekiq.configure_client do |config|
  config.redis = { url: connection_url }
end

Sidekiq.configure_server do |config|
  config.redis = { url: connection_url }
end
