require_relative '../../config/initializers/sidekiq'

class TransactionWorker
  include Sidekiq::Worker
  def perform(id)

  end
end
