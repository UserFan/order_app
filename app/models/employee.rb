class Employee < ApplicationRecord

  belongs_to :position

  belongs_to :shop
  belongs_to :user

  has_many :orders, inverse_of: :employee, dependent: :restrict_with_error
  has_many :tasks, inverse_of: :employee, dependent: :restrict_with_error
  has_many :performers, inverse_of: :employee, dependent: :restrict_with_error
  has_many :task_performers, inverse_of: :employee, dependent: :restrict_with_error
  has_one :profile, through: :user, foreign_key: :user_id

  validates :shop_id, :user_id, :work_start_date, :position, presence: true

  delegate_missing_to :user

  delegate :full_name, to: :profile

  delegate_missing_to :shop
  delegate_missing_to :position

  scope :current_employee, -> (user) { where("employees.work_start_date < ?
                               AND (employees.work_end_date is null
                               OR employees.work_end_date > ?)", Date.today,
                               Date.today).where(user_id: user).joins(:user) }


  def user_shop
    "#{name} (#{user.full_name})"
  end

  def full_name_with_position
    "#{full_name} (#{position.name})"
  end

  def full_name_with_structural
    "#{full_name} (#{shop.name})"
  end

  def self.employee_current(user)
    if self.current_employee(user).size > 1
      self.current_employee(user).where(temporary: true).first
    else
      self.current_employee(user).first
    end
  end

end
