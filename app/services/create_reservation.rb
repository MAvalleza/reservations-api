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
  #   CreateReservationValidation.run(params)
  # end

  def process
    @params
  end
end