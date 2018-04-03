class Performer < ApplicationRecord
  belongs_to :order
  belongs_to :user

  has_one :execution, dependent: :restrict_with_error
  has_many :reworks, through: :executions, foreign_key: :execution_id

end
