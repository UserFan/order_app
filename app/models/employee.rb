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

  scope :employee_current_date, -> { includes(:shop, :user, :position).
                                     where("employees.work_start_date <= ?
                                     AND (employees.work_end_date is null
                                     OR employees.work_end_date >= ?)",
                                     Date.today, Date.today) }

  scope :employee_user, -> (user) { employee_current_date.where(user_id: user).
                                    joins(:user) }

  scope :employee_current_manager, -> { employee_current_date.where(
                                         manager: true,
                                         temporary: true).
                                         or(employee_current_date.where.not(
                                             manager: false,
                                             temporary: true,
                                             shop_id: (employee_current_date.
                                                        where(manager: true,
                                                              temporary: true).
                                                               pluck(:shop_id)))) }
  scope :employee_current_usual, -> { employee_current_date.
                                       where(manager: false) }

  def full_name_with_position
    "#{full_name} (#{position.name})"
  end

  def full_name_with_structural
    "#{full_name} (#{shop.name})"
  end

  def structural_with_full_name
    "#{shop.name} (#{full_name})"
  end

  def structural_with_position
    "#{shop.name} (#{position.name})"
  end

  def self.employee_current(user)
    if self.employee_user(user).size > 1
      self.employee_user(user).where(temporary: true).first
    else
      self.employee_user(user).first
    end
  end

  def self.employee_current_position(user, temporary=false)
    position = self.employee_user(user).where(temporary: temporary).first
    position.structural_with_position unless position.nil?
  end

end
