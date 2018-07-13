class EquipmentType < ApplicationRecord
  has_many :service_equipments, inverse_of: :shop, dependent: :restrict_with_error

  validates :name, presence: true
end
