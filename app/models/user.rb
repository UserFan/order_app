class User < ApplicationRecord
  mount_uploader :avatar, ImageUploader

  belongs_to :role
  has_many :shops, dependent: :restrict_with_error
  has_many :performers, dependent: :restrict_with_error
  has_many :orders, through: :performers, foreign_key: :user_id
  has_many :executions, through: :performers, foreign_key: :user_id
  has_many :reworks, dependent: :restrict_with_error
  has_many :employees, dependent: :restrict_with_error

  has_one :profile, dependent: :destroy

  accepts_nested_attributes_for :profile, reject_if: :all_blank, allow_destroy: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  #after_create :create_profi

  delegate_missing_to :profile

  validates :role_id, presence: true

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
