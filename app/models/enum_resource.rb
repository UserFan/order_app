class EnumResource < ApplicationRecord
  has_many :template_accesses, dependent: :delete_all
  belongs_to :enum_action
  
  delegate_missing_to :enum_action

  validates :name, :resource_name, :enum_action_id, presence: true
end
