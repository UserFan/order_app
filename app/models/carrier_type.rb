class CarrierType < ApplicationRecord
  has_many :esps, dependent: :restrict_with_error

  validates :name, presence: true
end
