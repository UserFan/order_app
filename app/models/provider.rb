class Provider < ApplicationRecord
  has_many :item_communications, dependent: :restrict_with_error

  validates :name, presence: true
end
