class TaskRework < ApplicationRecord
  belongs_to :task_execution
  belongs_to :user

  validates :task_execution_id, :user_id, :comment, presence: true

end
