module Api
  module V1
    class ReservationsController < ApplicationController
      def create
        # Call service
        response = payload

        render json: response
      rescue InvalidPayloadFormatError
        render json: { error: { message: 'Invalid payload format' } }, status: 400
        # Return response
      end

      def index
        @reservations = Reservation.all

        render json: @reservations
      end

      def update
      end

      private

      def payload
        Reservations::PayloadFormatter.new(params).to_h
      end
    end
  end
end