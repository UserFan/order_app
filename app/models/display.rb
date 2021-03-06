class Display < ApplicationRecord
  has_many :cashboxes, dependent: :restrict_with_error
  has_many :computers, dependent: :restrict_with_error

  validates :name, presence: true
end
