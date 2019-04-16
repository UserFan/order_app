class ReportCostService < ApplicationRecord
  belongs_to :status
  has_many :service_equipments, inverse_of: :shop, dependent: :restrict_with_error

  validates :date_report, :status_id, presence: true
end
