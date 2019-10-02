class EspPolicy < UnitPolicy
  # def index?
  #   super || user.current_shops.include?(record.pluck(:shop_id))
  #   #binding.pry
  # end
  # def export_xls?
  #   (access_read?('export') || access_write?('export')) ||
  #   access_all?('export') || user.admin?
  # end

  # def link_new?
  #   user.shops.include?(record.shop)
  #   #binding.pry
  # end

  class Scope < Scope
    def resolve
     if access_set('default') == EnumTypeAccess::ALLALOWED || user.super_admin?
       scope.all
     elsif access_set('default') == EnumTypeAccess::READONLY || EnumTypeAccess::READWRITEONLY
       scope.where(shop_id: user.current_shops)
     end
    end
  end

  def permitted_attributes
    [:carrier_type_id, :kpp] if user.super_admin? || access_write?('default') || access_all?('default')
  end
end
