class EnumAction < ApplicationRecord
  has_many :enum_resources, dependent: :restrict_with_error

  delegate_missing_to :enum_resource

  validates :name, :action_name, presence: true

end
