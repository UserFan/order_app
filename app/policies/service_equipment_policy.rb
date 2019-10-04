class ServiceEquipmentPolicy < UnitPolicy
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
    [:date_service, :equipment_type_id, :shop_id, :amount,
     :description] if user.super_admin? || access_write?('default') || access_all?('default')
  end
end
