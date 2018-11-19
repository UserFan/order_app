class Employee < ApplicationRecord

  belongs_to :position

  belongs_to :shop
  belongs_to :user

  validates :shop_id, :user_id, :work_start_date, :manager, :position, presence: true


end
