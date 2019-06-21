class ActionApp < ApplicationRecord
  has_many :action_names, dependent: :restrict_with_error
  # has_many :computers, dependent: :restrict_with_error

  validates :name, :action_app_name, presence: true

end
