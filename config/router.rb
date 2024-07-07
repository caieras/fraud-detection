require_relative 'application'

class Router < Application  
  register Sinatra::Namespace

  before do
    content_type :json
  end

  namespace '/api' do
    get '/transactions' do
      Controllers::TransactionsController.new.index
    end

    post '/transactions/check' do
      Controllers::TransactionsController.new(request.body.read).fraud_check
    end
  end
end
