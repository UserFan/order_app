class EspPolicy < ApplicationPolicy

  # def index?
  #   super
  #   # binding.pry
  # end
  #
  # def show?
  #   index?
  # end
  #
  # # def create?
  # #   super
  # # end
  # #
  # # def new?
  # #   create?
  # # end
  #
  # def edit?
  #   index?
  # end
  #
  # def update?
  #   index?
  # end
  #
  # def destroy?
  #   index?
  # end

  # def new_record?(shop)
  #   access_write?('default') && !shop.nil?
  #   #   user.current_shops.where(id: shop).exists?
  #   # else
  #   #   return true if create?
  #   # end
  #   # binding.pry
  # end

  def export_xls?
    (access_read?('export') || access_write?('export')) ||
    access_all?('export') || user.admin?
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

  def permitted_attributes
    [:carrier_type_id, :kpp] if user.super_admin? || access_write?('default') || access_all?('default')
  end

  #private

  # def shop_user?(action_name)
  #   if access_all?(action_name)
  #     return true
  #   elsif (access_read?(action_name) || access_write?(action_name))
  #     #record.where(shop_id: user.current_shops).exists?
  #     user.current_shops.where(id: record.shop_id).exists?
  #   end
  # end

end
