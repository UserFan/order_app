class ShopCommunication < ApplicationRecord
  belongs_to :router
  belongs_to :shop

  has_many :item_communications, dependent: :restrict_with_error

  accepts_nested_attributes_for :item_communications, reject_if: :all_blank, allow_destroy: true

  validates :router_id, presence: true
end
