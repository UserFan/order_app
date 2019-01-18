class Employee < ApplicationRecord

  belongs_to :position

  belongs_to :shop
  belongs_to :user



  validates :shop_id, :user_id, :work_start_date, :position, presence: true

  #delegate_missing_to :user

  delegate_missing_to :shop


  def user_shop
    "#{user.full_name}(#{name})"
  end


end
