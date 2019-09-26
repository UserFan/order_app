class TemplateAccessPolicy < ApplicationPolicy

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
    [:name, :enum_type_access_id, :user_id, :enum_resource_id,
     :role_id] if user.super_admin? 
  end

end
