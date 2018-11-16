class Type < ApplicationRecord
  SHOP = 1
  PAVILION = 2
  SHOP_SELF_SERVICE = 3
  STRUCTURAL_UNIT = 4

  has_many :shops, dependent: :restrict_with_error

  validates :name, presence: true
end
