class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.string :code
      t.datetime :start_date
      t.datetime :end_date
      t.integer :nights
      t.integer :guests
      t.integer :adults
      t.integer :children
      t.integer :infants
      t.string :status
      t.string :guest_first_name
      t.string :guest_last_name
      t.string :guest_phone
      t.string :guest_email
      t.string :currency
      t.integer :payout_price
      t.integer :security_price
      t.integer :total_price

      t.timestamps
    end
  end
end
