class ReworkPolicy < ApplicationPolicy

  def new?
    true
  end

  def create?
    new?
  end

  def permitted_attributes
    [:execution_id, :user_id, :execution_work, :comment]
  end

end
