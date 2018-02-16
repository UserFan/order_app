class Weigher < ApplicationRecord
  has_many :shop_weighers, dependent: :restrict_with_error

  validates :name, presence: true

end
