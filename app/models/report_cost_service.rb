class ReportCostService < ApplicationRecord
  attr_accessor :type_service
  belongs_to :status
  has_many :service_equipments, inverse_of: :report_cost_service, dependent: :restrict_with_error

  validates :date_report, :status_id, :name_report, presence: true
end
