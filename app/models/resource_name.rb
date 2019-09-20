class ResourceName < ApplicationRecord
  has_many :action_names, dependent: :restrict_with_error

  validates :name, :table_name, presence: true
end
