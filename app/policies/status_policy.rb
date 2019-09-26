class StatusPolicy < ApplicationPolicy

  def edit?
    access_set('edit') || !(1..19).include?(record.id)
  end

  def update?
    edit?
  end

  def destroy?
    access_set('destroy') || !(1..19).include?(record.id)
  end

  def permitted_attributes
    [:name, role: []] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

end
