class UnitPolicy < ApplicationPolicy
  def new?
    access_all?('default') || user.super_admin? ||
    (access_write?('default') && user.current_shops.include?(record))
  end

  def access_unit?
    access_all?('default') || user.super_admin? ||
    ((access_read?('default') || access_write?('default')) && user.current_shops.include?(record))
  end

  class Scope < Scope
    def resolve
     if access_set('default') == EnumTypeAccess::ALLALOWED || user.super_admin?
       scope.all
     elsif access_set('default') == EnumTypeAccess::READONLY || EnumTypeAccess::READWRITEONLY
       scope.where(shop_id: user.current_shops)
     end
    end
  end
end
