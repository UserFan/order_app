class Role < ApplicationRecord
  USER_ID = 1
  GUIDE_ID = 2
  MODERATOR_ID = 3
  SUPER_ADMIN_ID = 4

  has_many :users, dependent: :restrict_with_error
  has_many :template_roles, dependent: :delete_all

  validates :name, presence: true
end
