# frozen_string_literal: true

class Rack::Attack
  throttle('req/ip', limit: 300, period: 1.minutes) do |req|
    req.ip
  end
end
