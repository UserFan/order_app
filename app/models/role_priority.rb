class RolePriority < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  validates :template_role, presence: true
end
