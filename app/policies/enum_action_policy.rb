class EnumActionPolicy < ApplicationPolicy

  def permitted_attributes
    [:name, :action_name] if user.super_admin?
  end
end
