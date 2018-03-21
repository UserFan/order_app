class User < ApplicationRecord
  belongs_to :position
  belongs_to :role
  has_many :shops, dependent: :restrict_with_error
  has_many :performers, dependent: :restrict_with_error
  has_many :orders, through: :performers, foreign_key: :user_id
  has_many :executions, through: :performers, foreign_key: :user_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :full_name, :role_id, :position_id, :mobile, presence: true

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

end
