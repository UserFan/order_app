class SystemUnitPolicy < ApplicationPolicy

  def permitted_attributes
    [:name, :cpu, :ram, :hdd, :motherboard, :os] if user.super_admin? || user.moderator?
  end

end
