class Order < ApplicationRecord
  mount_uploaders :photos, ImageUploader

  before_create :number_create

  belongs_to :category
  belongs_to :status
  belongs_to :shop

  has_many :performers, dependent: :destroy, autosave: true
  has_many :users, through: :performers, foreign_key: :user_id
  has_many :executions, through: :performers, foreign_key: :order_id

  validates :user_id, :date_open, :date_execution, :short_descript, presence: true

  def control_name
    User.find(self.user_id).full_name
  end

  def number_create
    unless order_number.present?
      self.order_number = "#{(category.name[0..1]).upcase}-#{Date.today.year}-#{id}"
    end
  end
end
