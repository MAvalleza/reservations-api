module Api
  module V1
    # Controller for Reservation endpoints
    class ReservationsController < ApplicationController
      def create
        # Format payload
        payload = formatted_payload
  
        # Call the service
        response = CreateReservation.run(payload)

        render Reservations::ResponseFormatter.new(response).to_h
      rescue InvalidPayloadFormatError
        render json: { error: { message: 'Invalid payload format' } }, status: :unprocessable_entity
        # Return response
      end

      def index
        @reservations = Reservation.all

        render json: @reservations
      end

      def show
        @reservation = Reservation.find_by(code: params[:id]) || {}
  
        render json: @reservation
      end

      def update
        # Format payload
        payload = formatted_payload

        # Call the service
        response = UpdateReservation.run(code: params[:id], params: payload)

        render Reservations::ResponseFormatter.new(response).to_h
      rescue InvalidPayloadFormatError
        render json: { error: { message: 'Invalid payload format' } }, status: :unprocessable_entity
      end

      private

      def formatted_payload
        Reservations::PayloadFormatter.new(params).to_h
      end
    end
  end
end