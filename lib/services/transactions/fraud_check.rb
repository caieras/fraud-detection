require 'pry'

module Services
  module Transactions
    class FraudCheck
      include Services::Helpers

      def self.call(transaction_params)
        new(transaction_params).call
      end

      def initialize(transaction_params)
        @transaction_params = transaction_params
        @response = ResponseBuilder.new
      end

      def call
        transaction = Models::Transaction.new(@transaction_params)
        
        return @response.fail(body: 'Invalid JSON Body').as_json unless transaction.valid?
        
        @response.success(body: 'nice').as_json
      end
    end
  end
end
