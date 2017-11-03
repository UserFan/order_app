class Status < ApplicationRecord
  has_many :order, dependent: :restrict_with_error
end
