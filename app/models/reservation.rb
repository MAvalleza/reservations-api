class Reservation < ApplicationRecord
  belongs_to :guest

  validates :code, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :nights, presence: true, numericality: true
  validates :guests, presence: true, numericality: true
  validates :adults, presence: true, numericality: true
  validates :children, presence: true, numericality: true
  validates :infants, presence: true, numericality: true
  validates :status, presence: true
  validates :currency, presence: true
  validates :payout_price, presence: true
  validates :security_price, presence: true
  validates :total_price, presence: true
end
