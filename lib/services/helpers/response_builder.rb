module Services
  module Helpers
    class ResponseBuilder
      attr_reader :status, :code, :body

      def initialize
        @status = :pending
      end

      def fail(status: :failed, code: 400, body: '')
        @status = status
        @code = code
        @body = body
        self
      end

      def success(status: :success, code: 200, body: '')
        @status = status
        @code = code
        @body = body
        self
      end

      def bad_request(status: :bad_request, code: 400, body: '')
        @status = status
        @code = code
        @body = body
        self
      end

      def as_json
        {
          code: @code,
          body: @body
        }.to_json
      end
    end
  end
end
