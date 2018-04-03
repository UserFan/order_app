class Rework < ApplicationRecord
  belongs_to :execution
  belongs_to :user

  validates :execution_id, :user_id, :comment, presence: true

end
