require 'sinatra/base'

class Application < Sinatra::Base
  configure do
    enable :logging
  end

  before do
    content_type :json
  end

  get '/transactions' do
    'hi'.to_json
  end
end
