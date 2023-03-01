class AddGuestToReservations < ActiveRecord::Migration[7.0]
  def change
    add_reference :reservations, :guest
  end
end
