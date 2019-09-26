class SystemUnitPolicy < ApplicationPolicy

  def permitted_attributes
    [:name, :cpu, :ram, :hdd, :motherboard, :os] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

end
