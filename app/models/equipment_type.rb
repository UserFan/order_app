class EquipmentType < ApplicationRecord
  has_many :service_equipments, dependent: :restrict_with_error

  validates :name, presence: true
end
