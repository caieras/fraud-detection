# frozen_string_literal: true

module Controllers
  class TransactionsController
    def initialize(params = {})
      @params = params
    end

    def index
      Services::Transactions::List.call
    end

    def fraud_check
      Services::Transactions::FraudCheck.call(validate_params)
    end

    private

    def validate_params
      permitted_params = %w[
        transaction_id
        merchant_id
        user_id
        card_number
        transaction_date
        transaction_amount
        device_id
      ]

      params = JSON.parse(@params) if @params.is_a?(String)
      params.select { |key, _| permitted_params.include?(key) }
    end
  end
end
