class User < ApplicationRecord
  #mount_uploader :avatar, ImageUploader

  belongs_to :role
  #has_many :performers, dependent: :restrict_with_error
  has_many :role_priorities, as: :imageable
  has_many :orders, through: :employee, foreign_key: :user_id
  has_many :executions, through: :performers, foreign_key: :user_id
  has_many :reworks, dependent: :restrict_with_error
  has_many :employees, dependent: :restrict_with_error
  has_many :shops, through: :employees, foreign_key: :user_id
  has_many :performers, through: :employees, foreign_key: :user_id
  has_many :task_performers, through: :employees, foreign_key: :user_id
  has_many :template_accesses, through: :role, foreign_key: :role_id


  has_one :profile, dependent: :destroy

  accepts_nested_attributes_for :profile, reject_if: :all_blank, allow_destroy: true

  before_create :locked_user

  ratyrate_rater

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  #after_create :create_profi

  delegate_missing_to :profile

  validates :role_id, presence: true

  def current_employees
    self.employees.employee_current_date
  end

  def current_shops
    if self.admin
      Shop.where(closed: nil, structural_unit: false)
    else
      self.shops.where("employees.work_start_date <= ?
      AND (employees.work_end_date is null
      OR employees.work_end_date >= ?)
      AND structural_unit = false AND closed is null",
      Date.today, Date.today)
    end
  end

  def super_admin?
    role_id == Role::SUPER_ADMIN_ID
  end

  def moderator?
    role_id == Role::MODERATOR_ID
  end

  def guide?
    role_id == Role::GUIDE_ID
  end

  def user?
    role_id == Role::USER_ID
  end

  private

  def locked_user
    self.locked_at = DateTime.now
  end



end
