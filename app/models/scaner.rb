class Scaner < ApplicationRecord
  has_many :cashboxes, dependent: :restrict_with_error
end
