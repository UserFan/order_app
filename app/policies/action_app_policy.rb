class ActionAppPolicy < ApplicationPolicy

  def permitted_attributes
    [:name, :action_app_name] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end
end
