class ActionNamePolicy < ApplicationPolicy

  def permitted_attributes
    [:name, :resource_name_id, :action_app_id] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end
end
