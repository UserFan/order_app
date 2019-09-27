class EnumAction < ApplicationRecord
  has_many :enum_resources, dependent: :delete_all

  validates :name, :action_name, presence: true

end
