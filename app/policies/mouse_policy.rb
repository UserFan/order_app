class MousePolicy < ApplicationPolicy

  def permitted_attributes
    [:name] if user.super_admin? || user.moderator?
  end

end
