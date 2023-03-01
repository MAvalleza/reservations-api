# Since reservation code and guest email must be unique, this validation ensures
# that there are no duplicates
class CreateReservationResourceValidation
  def initialize(code:, guest_email:)
    @code = code
    @guest_email = guest_email
  end

  def validate
    if @code.blank? || @guest_email.blank?
      return invalid_error
    elsif existing_guest?
      return duplicate_error(model: :guest, attribute: :email, value: @guest_email)
    elsif existing_reservation?
      return duplicate_error(model: :reservation, attribute: :code, value: @code)
    else
      {}
    end
  end

  private

  def duplicate_error(model:, attribute:, value:)
    Reservations::ErrorFormatter.new(
      errors: "#{model.capitalize} with #{attribute} #{value} already exists.",
      http_code: 409
    ).to_h
  end

  def invalid_error
    Reservations::ErrorFormatter.new(
      errors: "Reservation code and guest email are required. params #{@code}",
      http_code: 400
    ).to_h
  end

  def existing_guest?
    Guest.find_by(email: @guest_email).present?
  end

  def existing_reservation?
    Reservation.find_by(code: @code).present?
  end
end
