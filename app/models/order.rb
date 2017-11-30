class Order < ApplicationRecord
  mount_uploaders :photos, ImageUploader

  belongs_to :category
  belongs_to :status
  belongs_to :shop
  belongs_to :user

  validates :category_id, :date_open, :date_execution, :short_descript, :status_id, presence: true
end
