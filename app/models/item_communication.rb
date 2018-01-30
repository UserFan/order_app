class ItemCommunication < ApplicationRecord
  belongs_to :shop_communication
  belongs_to :provider
  belongs_to :communication


  validates :provider_id, :communication_id, presence: true
end
