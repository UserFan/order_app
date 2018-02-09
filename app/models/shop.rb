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
  has_many :computers, inverse_of: :shop, dependent: :restrict_with_error
  has_many :shop_weighers, inverse_of: :shop, dependent: :restrict_with_error
  has_many :shop_communications, inverse_of: :shop, dependent: :restrict_with_error

  accepts_nested_attributes_for :cashboxes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :computers, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :shop_weighers, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :shop_communications, reject_if: :all_blank, allow_destroy: true

  validates :name, :address, :type_id, :user_id, presence: true

end
