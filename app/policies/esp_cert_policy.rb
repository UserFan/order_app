class EspCertPolicy < ApplicationPolicy

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

  def new_record?(shop)
    if access_only?('new') && !shop.nil?
      user.current_shops.where(id: shop).exists?
    else
      return true if create?
    end
  end

  def export_xls?
    shop_user?('export') || access_all?('export') || user.admin?
  end

  class Scope < Scope
    def resolve
      if access_set('default') == EnumTypeAccess::ALLALOWED || user.super_admin?
        scope.all
      elsif access_set('default') == (EnumTypeAccess::READONLY || EnumTypeAccess::READWRITEONLY)
        scope.joins(:esp).where(esps: { shop_id: user.current_shops })
      end
    end
  end

  def permitted_attributes
    [:date_start_esp, :date_end_esp, :serial_num_esp, :rsa_serial,
     :date_start_rsa, :date_end_rsa] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

  private

  def shop_user?(action_name)
    if access_all?(action_name)
      return true
    elsif access_read?(action_name)
      if action_name == 'default'
        user.current_shops.where(id: record.shop_id).exists?
      else
        record.joins(:esp).where(esps: { shop_id: user.current_shops }).exists?
      end
    end
  end

end
