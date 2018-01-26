class Shop < ApplicationRecord
  mount_uploader :photo, ImageUploader

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, :if => lambda{ |obj| obj.address_changed? }
  after_validation :reverse_geocode

  belongs_to :user
  belongs_to :type
  has_many :orders, dependent: :restrict_with_error
  has_many :cashboxes, inverse_of: :shop, dependent: :restrict_with_error
  #has_many :cash_images, through: :cashboxes
  accepts_nested_attributes_for :cashboxes, reject_if: :all_blank, allow_destroy: true
  #accepts_nested_attributes_for :cash_images, reject_if: :all_blank, allow_destroy: true
end
