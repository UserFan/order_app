class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :full_name, :position, :role, :mobile, presence: true

  enum role: [:user, :vip, :admin, :super_admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user

  end

    # def super_admin?
    #   self.admin
    # end

end
