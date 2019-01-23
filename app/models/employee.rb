class Employee < ApplicationRecord

  belongs_to :position

  belongs_to :shop
  belongs_to :user

  has_many :orders, inverse_of: :employee, dependent: :restrict_with_error
  has_many :performers, inverse_of: :employee, dependent: :restrict_with_error


  validates :shop_id, :user_id, :work_start_date, :position, presence: true

  delegate_missing_to :user

  delegate_missing_to :shop


  def user_shop
    "#{name} (#{user.full_name})"
  end


end
