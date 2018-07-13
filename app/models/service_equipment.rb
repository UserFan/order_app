class ServiceEquipment < ApplicationRecord
  belongs_to :equipment_type
  belongs_to :shop

  validates :date_service, :equipment_type_id, presence: true
end
