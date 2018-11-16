class TypePolicy < ApplicationPolicy

  def update?
   edit?
  end

  def edit?
    return false if (1..4).include?(record.id)
    super
  end

  def destroy?
    edit?
  end

  def permitted_attributes
    [:name] if user.super_admin? || user.moderator?
  end

end
