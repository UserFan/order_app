class Order < ApplicationRecord
  mount_uploaders :photos, ImageUploader

  belongs_to :category
  belongs_to :status
  belongs_to :shop
  belongs_to :user
  has_many :performers, inverse_of: :order, dependent: :restrict_with_error

  accepts_nested_attributes_for :performers, reject_if: :all_blank, allow_destroy: true

  validates :category_id, :date_open, :date_execution, :short_descript, :status_id, presence: true
end
