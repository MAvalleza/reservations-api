class CreateReservation < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def perform
    errors = validate

    return errors unless errors.empty?

    process 
  end

  private

  def validate
    CreateReservationResourceValidation.new(
      code: params[:code],
      guest_email: params[:guest_email]
    ).validate
  end
  
  def process
    guest = Guest.new(
      email: params[:guest_email],
      first_name: params[:guest_first_name],
      last_name: params[:guest_last_name],
      phone: params[:guest_phone]
    )

    if !guest.valid?
      return Reservations::ErrorFormatter.new(errors: guest.errors.full_messages, http_code: 400).to_h
    end
  
    reservation = guest.build_reservation(reservation_details)

    if !reservation.valid?
      return Reservations::ErrorFormatter.new(errors: reservation.errors.full_messages, http_code: 400).to_h
    end

    # Save records
    guest.save
    reservation.save
  
    {
      data: reservation.as_json.merge(guest: guest.as_json),
      status: 200
    }
  end

  def reservation_details
    params.except(:guest_email, :guest_first_name, :guest_last_name, :guest_phone)
  end
end
