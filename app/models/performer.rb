class Performer < ApplicationRecord
  belongs_to :order
  belongs_to :user

  validates :order_id, :user_id, :date_performance, presence: true
end
