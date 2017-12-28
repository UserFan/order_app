class ApcPolicy < ApplicationPolicy

  def permitted_attributes
    [:name] if user.super_admin? || user.moderator?
  end

end
