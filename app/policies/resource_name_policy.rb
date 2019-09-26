class ResourceNamePolicy < ApplicationPolicy

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
    [:name, :table_name] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

end
