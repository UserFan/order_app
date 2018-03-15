class ExecutionPolicy < ApplicationPolicy

  def new?
    true
  end

  def index?
    true
  end

  def create?
    new?
  end

  def show?
    new?
  end

  def update?
    new?
  end

  def edit?
    new?
  end

  def destroy?
    return true if user.super_admin?
    false
  end


  def permitted_attributes
    [:performer_id, :comment, :order_execution, images:[]]
  end

end
