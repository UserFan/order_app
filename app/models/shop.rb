class Shop < ApplicationRecord
  mount_uploader :photo, ImageUploader

  scope :structural_unit, -> { where(structural_unit: true) }
  scope :shop_unit, -> { where(structural_unit: false) }


  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, :if => lambda{ |obj| obj.address_changed? }
  after_validation :reverse_geocode

  #belongs_to :user, counter_cache: true
  belongs_to :type, optional: true

  has_many :esps, inverse_of: :shop, dependent: :restrict_with_error
  has_many :service_equipments, inverse_of: :shop, dependent: :restrict_with_error
  has_many :cost_equipments, inverse_of: :shop, dependent: :restrict_with_error
  has_many :version_update_logs, inverse_of: :shop, dependent: :restrict_with_error
  has_many :orders, dependent: :restrict_with_error
  has_many :cashboxes, inverse_of: :shop, dependent: :restrict_with_error
  has_many :computers, inverse_of: :shop, dependent: :restrict_with_error
  has_many :shop_weighers, inverse_of: :shop, dependent: :restrict_with_error
  has_many :shop_communications, inverse_of: :shop, dependent: :restrict_with_error
  has_many :item_communications, through: :shop_communications, foreign_key: :shop_id  
  has_many :employees, dependent: :restrict_with_error
  has_many :users, through: :employees, foreign_key: :shop_id

  accepts_nested_attributes_for :cashboxes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :computers, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :shop_weighers, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :shop_communications, reject_if: :all_blank, allow_destroy: true

  default_scope { order(name: :asc) }

  validates :name, :address, :user_id, presence: true
  validates :type_id, present: true unless :structural_unit
end
