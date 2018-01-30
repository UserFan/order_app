class Router < ApplicationRecord
  has_many :shop_communications, dependent: :restrict_with_error
end
