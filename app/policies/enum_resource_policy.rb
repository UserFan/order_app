class EnumResourcePolicy < ApplicationPolicy

  def index?
    user.super_admin?
  end

  def show?
    index?
  end

  def create?
    index?
  end

  def new?
    index?
  end

  def update?
    index?
  end

  def edit?
    index?
  end

  def destroy?
    user.super_admin? && record.can_destroy?
  end

  def permitted_attributes
    [:name, :resource_name, :enum_action_id] if user.super_admin?
  end

end
