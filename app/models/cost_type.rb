class CostType < ApplicationRecord
  has_many :cost_equipments, dependent: :restrict_with_error

  validates :name, presence: true
end
