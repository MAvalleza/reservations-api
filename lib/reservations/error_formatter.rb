module Reservations
  class ErrorFormatter
    def initialize(errors:, http_code:)
      @errors = errors
      @http_code = http_code
    end

    def to_h
      {
        errors: @errors,
        status: @http_code
      }
    end
  end
end
