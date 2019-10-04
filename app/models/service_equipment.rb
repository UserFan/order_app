class ServiceEquipment < ApplicationRecord
  belongs_to :equipment_type
  belongs_to :shop
  belongs_to :report_cost_service, optional: true

  validates :date_service, :equipment_type_id, :amount, presence: true

  scope :service_period_count,
    -> (date_start) { by_month(date_start, field: :date_service).size }
end
