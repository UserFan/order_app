class StatusPolicy < ApplicationPolicy

  def permitted_attributes
    [:name, role: []] if user.super_admin? || user.moderator?
  end

end
