class TemplateRolePolicy < ApplicationPolicy

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
    [:name, :type_access, :action_name_id,
     :role_id] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

end
