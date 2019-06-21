class ActionName < ApplicationRecord
  belongs_to :resource_name
  belongs_to :action_app
  has_many :template_roles, dependent: :restrict_with_error

  delegate_missing_to :resource_name
  validates :name, :resource_name_id, :action_app_id, presence: true
  validates_uniqueness_of :action_app_id, scope: :resource_name_id

  def resource_name_action_app_name
    "#{resource_name.name}-#{action_app.name}"
  end

  # def name
  #   "#{resource_name.name}-#{action_app.name}"
  # end
end
