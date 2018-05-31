class SimCard < ApplicationRecord
  has_many :item_communications, dependent: :restrict_with_error
  belongs_to :provider
  has_many :shop_communications, through: :item_communications
  has_many :shops, through: :shop_communications
  validates :sim_number, :simphone_number, :provider_id, presence: true
end
