class UpdateReservation < ApplicationService
  attr_reader :params, :code

  def initialize(args)
    @code = args[:code]
    @params = args[:params]
  end

  def perform
    raise ReservationNotFoundError if reservation.blank?

    updated_reservation = reservation.update(update_params)

    if updated_reservation
      return {
        data: reservation.attributes.merge(guest: guest.attributes),
        status: 200
      }
    else
      Reservations::ErrorFormatter.new(errors: "There was an error in updating the reservation.", http_code: 400).to_h
    end
  rescue ReservationNotFoundError
    Reservations::ErrorFormatter.new(errors: "No reservation with code #{code} exists.", http_code: 400).to_h
  end

  private

  def guest
    @guest ||= begin
      Guest.find(reservation.guest_id)
    rescue ActiveRecord::RecordNotFound
      {}
    end
  end

  def reservation
    @reservation ||= Reservation.find_by(code: code)
  end

  def update_params
    # Main guest details not included in update, we limit to reservation updates only
    # Code and id attributes not included as well
    params_to_scrub = %i[
      guest_email
      guest_first_name
      guest_last_name
      guest_phone
      code
      id
    ]

    params.except(*params_to_scrub).compact
  end
end
