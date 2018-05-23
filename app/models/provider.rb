class Provider < ApplicationRecord
  has_many :item_communications, dependent: :restrict_with_error
  has_many :sim_cards, dependent: :restrict_with_error
  has_many :shop_communication, through: :item_communications
  has_many :shop, through: :shop_communication
  validates :name, presence: true
end
