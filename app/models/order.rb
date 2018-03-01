class Order < ApplicationRecord
  mount_uploaders :photos, ImageUploader

  belongs_to :category
  belongs_to :status
  belongs_to :shop


  #has_many :physicians, through: :appointments

  has_many :performers, inverse_of: :order, dependent: :restrict_with_error
  has_many :users, through: :performers, foreign_key: :user_id
  has_many :executions, through: :performers, foreign_key: :order_id
  #accepts_nested_attributes_for :performers, reject_if: :all_blank, allow_destroy: true

  validates :user_id, :date_open, :date_execution, :short_descript, presence: true
  #validate :exec_dates

  validate :val_date_execution



  def control_name

    User.find(self.user_id).full_name

  end

  
end
