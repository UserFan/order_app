class ExecutionPolicy < ApplicationPolicy

  def new?
    true
  end

  def index?
    new?
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
    new?
  end

  def permitted_attributes
    [:performer_id, :comment, :order_execution, :images[]] 
  end

end
