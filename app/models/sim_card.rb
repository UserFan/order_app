class SimCard < ApplicationRecord
  has_many :item_communications, dependent: :restrict_with_error
  belongs_to :provider
  has_many :shop_communications, through: :item_communications
  has_many :shops, through: :shop_communications
  has_many :sim_logs, dependent: :restrict_with_error

  validates :sim_number, :simphone_number, :provider_id, presence: true

  delegate_missing_to :provider
end
