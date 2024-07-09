module Services
  module RiskEngine
    module Rules
      class ChargebackHistory
        def self.check(user_id, redis)
          new(user_id, redis).check
        end

        def initialize(user_id, redis)
          @user_id = user_id
          @redis = redis
        end

        def check
          if had_chargeback?
            { passed: false, message: 'Bad chargeback history' }
          else
            { passed: true }
          end
        end

        private

        def had_chargeback?
          chargeback_key = "user:#{@user_id}:chargeback"
          @redis.exists?(chargeback_key)
        end
      end
    end
  end
end
