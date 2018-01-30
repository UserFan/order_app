class Weigher < ApplicationRecord
  has_many :shop_weighers, dependent: :restrict_with_error
end
