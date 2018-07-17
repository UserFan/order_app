class CostEquipment < ApplicationRecord
  belongs_to :cost_type
  belongs_to :shop

  validates :date_cost, :cost_type, presence: true
end
