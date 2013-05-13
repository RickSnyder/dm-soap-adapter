class SoapAdapter::Connection
  module Errors
    class Error             < StandardError; end
    class FieldNotFound     < Error; end
    class LoginFailed       < Error; end
    class SessionTimeout    < Error; end
    class UnknownStatusCode < Error; end
    class ServerUnavailable < Error; end


    class SoapError < Error
      def initialize(message, result)
        @result = result
        super("#{message}: #{result.inspect}")
      end

      def records
        @result.to_a
      end

      def failed_records
        @result.reject {|r| r.success}
      end

      def successful_records
        @result.select {|r| r.success}
      end

      def result_message
        failed_records.map do |r|
          message_for_record(r)
        end.join("; ")
      end

      def message_for_record(record)
        record.errors.map {|e| "#{e.statusCode}: #{e.message}"}.join(", ")
      end

      def server_unavailable?
        failed_records.any? do |record|
          record.errors.any? {|e| e.statusCode == "SERVER_UNAVAILABLE"}
        end
      end
    end
    class CreateError    < SoapError; end
    class QueryError     < SoapError; end
    class DeleteError    < SoapError; end
    class UpdateError    < SoapError; end
  end
end