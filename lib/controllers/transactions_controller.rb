module Controllers
  class TransactionsController
    def initialize(params = {})
      @params = params
    end

    def index
      Services::Transactions::List.call
    end

    def fraud_check      
    end

    private

    attr_reader :params

    def transaction_params
      validated = {}
      
      validated["transaction_id"] = params["transaction_id"].to_i if params["transaction_id"].to_s.match?(/^\d+$/)
      validated["merchant_id"] = params["merchant_id"].to_i if params["merchant_id"].to_s.match?(/^\d+$/)
      validated["user_id"] = params["user_id"].to_i if params["user_id"].to_s.match?(/^\d+$/)
      validated["card_number"] = params["card_number"] if params["card_number"].to_s.match?(/^\d{6}\*{6}\d{4}$/)
      validated["transaction_date"] = DateTime.parse(params["transaction_date"]) rescue nil
      validated["transaction_amount"] = params["transaction_amount"].to_f if params["transaction_amount"].to_s.match?(/^\d+(\.\d+)?$/)
      validated["device_id"] = params["device_id"].to_i if params["device_id"].to_s.match?(/^\d*$/)
    
      validated
    end
  end
end
