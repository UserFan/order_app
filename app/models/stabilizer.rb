class Stabilizer < ApplicationRecord
  has_many :cashboxes, dependent: :restrict_with_error
  has_many :computers, dependent: :restrict_with_error
end
