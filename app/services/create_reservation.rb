class CreateReservation < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def perform
    # errors = validate

    # return errors unless errors.empty?

    process
  end

  private

  # Validate payload params
  # def validate

  # end

  def process
    guest = create_guest

    return format_errors(guest.errors.full_messages, 400) unless guest.valid?
  end

  def create_guest
    Guest.create(
      email: params[:guest_email],
      first_name: params[:guest_first_name],
      last_name: params[:guest_last_name],
      phone: params[:guest_phone]
    )
  end

  def format_errors(errors, http_code)
    {
      errors: errors,
      status: http_code
    }
  end
end