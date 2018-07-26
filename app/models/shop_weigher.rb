class ShopWeigher < ApplicationRecord

  belongs_to :weigher
  belongs_to :shop, counter_cache: true

end
