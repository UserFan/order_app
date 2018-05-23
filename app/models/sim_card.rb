class SimCard < ApplicationRecord
  has_many :item_communications, dependent: :restrict_with_error
  belongs_to :provider
  has_one :shop, through: :provider

  validates :sim_number, :simphone_number, :provider_id, presence: true
end
