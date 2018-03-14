class Performer < ApplicationRecord
  belongs_to :order
  belongs_to :user

  has_one :execution, dependent: :restrict_with_error

  #validates :order_id, :date_performance, presence: true
end
