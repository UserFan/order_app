class Position < ApplicationRecord
  has_many :profiles, dependent: :restrict_with_error
  validates :name, presence: true
end
