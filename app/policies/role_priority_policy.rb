class RolePriorityPolicy < ApplicationPolicy

  def permitted_attributes
    [:template_role] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end
end
