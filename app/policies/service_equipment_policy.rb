class ServiceEquipmentPolicy < ApplicationPolicy

  def index?
    super ||
    shop_user?('index')
  end

  def show?
    super ||
    shop_user?('show')
  end

  def create?
    super ||
    shop_user?('new')
  end

  def new?
    create?
  end

  def new_record?(shop)
    if create? && !shop.nil?
      user.current_shops.where(id: shop).exists?
    else
      return true
    end
  end

  def edit?
    update?
  end

  def update?
    super ||
    shop_user?('edit')
  end

  def destroy?
    super ||
    shop_user?('destroy')
  end

  class Scope < Scope
    def resolve
      if access_set('index') == 'allowed_all' || user.super_admin?
        scope.all
      elsif access_set('index') == 'allowed_current'
        scope.where(shop_id: user.current_shops)
      end
    end
  end

  def new_only?
    access_only?('new')
  end


  def permitted_attributes
    [:date_service, :equipment_type_id, :shop_id, :amount,
     :description] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

  private

  def shop_user?(action_name)
    if access_only?(action_name)
      if action_name == 'edit' || action_name == 'destroy'
        user.current_shops.where(id: record.shop_id).exists?
      else
        record.where(shop_id: user.current_shops).exists?
      end
    else
      return true if access_all?(action_name)
    end
  end
end
