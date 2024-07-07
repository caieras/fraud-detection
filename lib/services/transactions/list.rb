module Services
  module Transactions
    class List
      def self.call
        new.call
      end

      def call
        transaction_list = Models::Transaction.all
        build_response(transaction_list)
      rescue StandardError => e
        build_error_response(e)
      end

      private

      def build_response(transaction_list)
        if transaction_list.any?
          { status: 200, body: transaction_list }.to_json
        else
          { status: 200, body: 'No Content' }.to_json
        end
      end

      def build_error_response(error)
        [500, { error: error.message }.to_json]
      end
    end
  end
end
