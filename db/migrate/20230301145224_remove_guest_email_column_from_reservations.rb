class RemoveGuestEmailColumnFromReservations < ActiveRecord::Migration[7.0]
  def change
    remove_column :reservations, :guest_email
  end
end
