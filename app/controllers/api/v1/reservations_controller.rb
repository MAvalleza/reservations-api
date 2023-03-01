module Api
  module V1
    class ReservationsController < ApplicationController
      def create
        # Format payload
        payload = formatted_payload
  
        # Call the service
        response = CreateReservation.run(params: payload)

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

      def formatted_payload
        Reservations::PayloadFormatter.new(params).to_h
      end
    end
  end
end