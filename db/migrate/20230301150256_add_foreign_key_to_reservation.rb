class AddForeignKeyToReservation < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :reservations, :guests
  end
end
