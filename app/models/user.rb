class User < ApplicationRecord
  belongs_to :position
  belongs_to :role
  #belongs_to :order
  has_many :shops, dependent: :restrict_with_error
  #has_many :orders, dependent: :restrict_with_error

  has_many :performers, dependent: :restrict_with_error
  has_many :orders, through: :performers, foreign_key: :user_id
  has_many :executions, through: :performers, foreign_key: :user_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :full_name, :role_id, :position_id, :mobile, presence: true

  def super_admin?
    self.role_id == 4
  end

  def moderator?
    self.role_id == 3
  end

  def guide?
    self.role_id == 2
  end

  def user?
    self.role_id == 1
  end

end
