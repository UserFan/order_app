class StatusPolicy < ApplicationPolicy

  def update?
   edit?
  end

  def edit?
    return false if (1..6).include?(record.id)
    super
  end

  def destroy?
    return false if (1..6).include?(record.id)
    super
  end

  def permitted_attributes
    [:name, role: []] if user.super_admin? || user.moderator?
  end

end
