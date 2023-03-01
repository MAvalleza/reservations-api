class Guest < ApplicationRecord
  has_one :reservation, dependent: :destroy
  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
end
