class BankUnit < ApplicationRecord
  has_many :cashbox, dependent: :restrict_with_error
end