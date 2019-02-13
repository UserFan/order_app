class TaskReworkPolicy < ApplicationPolicy

  def new?
    true
  end

  def create?
    new?
  end

  def permitted_attributes
    [:task_execution_id, :user_id, :comment]
  end

end
