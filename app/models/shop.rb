class Shop < ApplicationRecord
  mount_uploader :photo, ImageUploader

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
  has_many :tasks, dependent: :restrict_with_error, foreign_key: :structural_id
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

  scope :structural_unit, -> { where(structural_unit: true) }
  scope :shop_unit, -> { where(structural_unit: false) }
  scope :shop_employees, -> (user) { joins(:employees).
                             where("employees.work_start_date < ?
                               AND (employees.work_end_date is null
                               OR employees.work_end_date > ?)", Date.today,
                               Date.today).where(employees: {user_id: user}) }


  validates :name, :address, presence: true
  validates :type_id, present: true unless :structural_unit

  def shop_manager
    self.employees.where('manager=true and (work_start_date <= ? and (work_end_date is null or work_end_date >= ?))',
                         DateTime.now, DateTime.now).order(:temporary)
  end
end
