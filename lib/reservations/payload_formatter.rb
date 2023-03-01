module Reservations
  class PayloadFormatter
    def initialize(params)
      @params = params
      @symbolized_params = @params.permit!.to_h.deep_symbolize_keys
    end

    def to_h
      raise InvalidPayloadFormatError if @symbolized_params[:data].blank?

      parse_params(@symbolized_params[:data])
    end

    private

    def parse_params(data)
      return formatted_reservation_details_payload if reservation_details.present?

      # First payload type handling
      {
        code: data[:reservation_code],
        start_date: data[:start_date],
        end_date: data[:end_date],
        nights: data[:nights],
        guests: data[:guests],
        adults: data[:adults],
        children: data[:children],
        infants: data[:infants],
        status: data[:status],
        guest_email: data.dig(:guest, :email),
        guest_first_name: data.dig(:guest, :first_name),
        guest_last_name: data.dig(:guest, :last_name),
        guest_phone: data.dig(:guest, :phone),
        currency: data[:currency],
        payout_price: data[:payout_price],
        security_price: data[:security_price],
        total_price: data[:total_price]
      }
    end

    def formatted_reservation_details_payload
      {
        code: reservation_details[:code],
        start_date: reservation_details[:start_date],
        end_date: reservation_details[:end_date],
        nights: reservation_details[:nights],
        guests: guest_counter,
        adults: reservation_details[:guest_details].dig(:number_of_adults),
        children: reservation_details[:guest_details].dig(:number_of_children),
        infants: reservation_details[:guest_details].dig(:number_of_infants),
        status: reservation_details[:status_type],
        guest_email: reservation_details[:guest_email],
        guest_first_name: reservation_details[:guest_first_name],
        guest_last_name: reservation_details[:guest_last_name],
        guest_phone: reservation_details[:guest_phone_numbers],
        currency: reservation_details[:host_currency],
        payout_price: reservation_details[:expected_payout_amount],
        security_price: reservation_details[:listing_security_price_accurate],
        total_price: reservation_details[:total_paid_amount_accurate]
      }
    end

    def guest_counter
      reservation_details_guest_attributes = %i[
        number_of_adults
        number_of_children
        number_of_infants
      ]

      count = reservation_details_guest_attributes.sum do |attribute|
        reservation_details.dig(:guest_details, attribute)
      end

      count
    end

    # Handles the 2nd type of paylaod
    def reservation_details
      @symbolized_params[:data].dig(:reservation)
    end
  end
end
