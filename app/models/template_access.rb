class TemplateAccess < ApplicationRecord
  belongs_to :role
  belongs_to :enum_resource
  belongs_to :enum_type_access
  has_many :users, through: :role, foreign_key: :role_id

  delegate_missing_to :enum_resource
  delegate_missing_to :enum_type_access

  validates :name, :enum_type_access_id, :enum_resource_id, :role_id,
            :user_id, presence: true

end
