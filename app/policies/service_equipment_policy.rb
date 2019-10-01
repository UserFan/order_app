class ServiceEquipmentPolicy < ApplicationPolicy
  #
  # def index?
  #   super ||
  #   shop_user?('default')
  # end
  #
  # def show?
  #   super ||
  #   shop_user?('default')
  # end
  #
  # def create?
  #   super ||
  #   shop_user?('default')
  # end
  #
  # def new?
  #   create?
  # end
  #
  # def new_record?(shop)
  #   if create? && !shop.nil?
  #     user.current_shops.where(id: shop).exists?
  #   else
  #     return true
  #   end
  # end
  #
  # def edit?
  #   update?
  # end
  #
  # def update?
  #   super ||
  #   shop_user?('default')
  # end
  #
  # def destroy?
  #   super ||
  #   shop_user?('default')
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

  # def new_only?
  #   access_write?('default')
  # end


  def permitted_attributes
    [:date_service, :equipment_type_id, :shop_id, :amount,
     :description] if user.super_admin? || access_write?('default') || access_all?('default')
  end

  # private
  #
  # def shop_user?(action_name)
  #   if access_write?(action_name)
  #     user.current_shops.where(id: record.shop_id).exists?
  #   else
  #     record.where(shop_id: user.current_shops).exists?
  #   end
  #   return true if access_all?(action_name)
  # end
end
