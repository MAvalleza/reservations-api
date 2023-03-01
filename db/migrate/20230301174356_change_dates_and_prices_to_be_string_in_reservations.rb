class ChangeDatesAndPricesToBeStringInReservations < ActiveRecord::Migration[7.0]
  def change
    change_column :reservations, :start_date, :string
    change_column :reservations, :end_date, :string
    change_column :reservations, :payout_price, :string
    change_column :reservations, :security_price, :string
    change_column :reservations, :total_price, :string
  end
end
