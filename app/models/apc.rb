class Apc < ApplicationRecord
  has_many :cashboxes, dependent: :restrict_with_error
  
  validates :name, presence: true
end
