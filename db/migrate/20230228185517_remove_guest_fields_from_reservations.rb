class RemoveGuestFieldsFromReservations < ActiveRecord::Migration[7.0]
  def change
    remove_column :reservations, :guest_first_name
    remove_column :reservations, :guest_last_name
    remove_column :reservations, :guest_phone
  end
end
