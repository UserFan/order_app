class Communication < ApplicationRecord
  has_many :item_communications, dependent: :restrict_with_error
end
