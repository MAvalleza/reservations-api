module Reservations
  class ResponseFormatter
    def initialize(params)
      @params = params
    end

    def to_h
      if @params[:errors].present?
        {
          json: { errors: @params[:errors] },
          status: @params[:status]
        }

      else
        {
          json: @params[:data],
          status: @params[:status]
        }
      end
    end
  end
end
