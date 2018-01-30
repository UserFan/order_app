class ShopWeigher < ApplicationRecord
  belongs_to :weigher
  belongs_to :shop

  validates :weigher_id, presence: true
end
