class Provider < ApplicationRecord
  has_many :item_communications, dependent: :restrict_with_error
  has_many :sim_cards, dependent: :restrict_with_error
  
  validates :name, presence: true
end
