class TypePolicy < ApplicationPolicy

  def update?
   edit?
  end

  def edit?
    access_type?('edit') || !(1..4).include?(record.id)
  end

  def destroy?
    access_type?('destroy') || !(1..4).include?(record.id)
  end

  def permitted_attributes
    [:name] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

end
