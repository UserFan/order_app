class Printer < ApplicationRecord
  has_many :computers, dependent: :restrict_with_error
end
