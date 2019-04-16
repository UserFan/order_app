class ServiceEquipment < ApplicationRecord
  belongs_to :equipment_type
  belongs_to :shop
  belongs_to :report_cost_service, optional: true

  validates :date_service, :equipment_type_id, :amount, presence: true
end
