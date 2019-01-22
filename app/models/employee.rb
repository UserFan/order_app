class Employee < ApplicationRecord

  belongs_to :position

  belongs_to :shop
  belongs_to :user

  has_many :orders, foreign_key: :answerable_manager, dependent: :destroy #, autosave: true



  validates :shop_id, :user_id, :work_start_date, :position, presence: true

  #delegate_missing_to :user

  delegate_missing_to :shop


  def user_shop
    "#{name}(#{user.full_name})"
  end


end
