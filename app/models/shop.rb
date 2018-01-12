class Shop < ApplicationRecord
  mount_uploader :photo, ImageUploader

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, :if => lambda{ |obj| obj.address_changed? }
  after_validation :reverse_geocode

  belongs_to :user
  belongs_to :type
  has_many :order, dependent: :restrict_with_error
  has_many :cashbox, dependent: :restrict_with_error
end
