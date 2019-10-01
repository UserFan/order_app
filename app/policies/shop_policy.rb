class ShopPolicy < ApplicationPolicy

  def destroy?
    return false if record.closed.present?
    user.super_admin?
  end

  def show_unit?
    !record.structural_unit
  end

  def import_version?
    access_all?('cash_version_update') ||
    user.super_admin? ||
    shop_user?('cash_version_update')
    #binding.pry
  end

  def cash_images?
    show?
  end

  def show_specialty?
    show?
  end

  def show?
    super ||
    shop_user?('show')
  end

  def show_info?(action_tabl)
    access_info?(action_tabl, 'show') || user.super_admin?
  end

  def export_xls?(action_tabl)
    access_info?(action_tabl, 'export') || user.super_admin?
  end

  def version_update?
    user.super_admin?
  end

  def export_shops?
    access_all?('export') || access_write?('export') || user.super_admin?
  end

  class Scope < Scope
    def resolve
      if access_set('default') == EnumTypeAccess::ALLALOWED || user.super_admin?
        scope.all
      elsif access_set('default') == EnumTypeAccess::READONLY || EnumTypeAccess::READWRITEONLY
        scope.where(id: user.current_shops)
      end
    end
  end


  def permitted_attributes
    [:name, :email, :address, :type_id, :photo, :closed, :orders_take,
     cashboxes_attributes: [:id, :shop_id, :display_id, :display_sn,
                            :system_unit_id, :system_unit_sn, :keyboard_id,
                            :keyboard_sn, :display_client_id, :display_client_sn,
                            :stabilizer_id, :stabilizer_sn,:apc_id, :apc_sn,
                            :scaner_id, :scaner_sn, :bank_unit_id, :terminal_sn,
                            :fiscal_id, :fiscal_sn, :organization_unit_id,
                            :cashbox_photos_id, :ip_cash, :comment, :_destroy,
     cash_images_attributes: [:id, :cashbox_id, :date_add, :_destroy, images: []]],
     computers_attributes: [:id, :shop_id, :display_id, :display_sn,
                            :system_unit_id, :system_unit_sn, :keyboard_id,
                            :keyboard_sn, :commouse_id, :commouse_sn,
                            :stabilizer_id, :stabilizer_sn, :printer_id,
                            :printer_sn, :teamview_id, :ip_address, :comment,
                             :_destroy],
     shop_weighers_attributes: [:id, :shop_id, :weigher_id, :weigher_sn,
                                :ip_address, :comment, :_destroy],
     shop_communications_attributes: [:id, :shop_id, :router_id, :router_sn,
                                      :_destroy,
     item_communications_attributes: [:id, :shop_communication_id, :provider_id,
                                      :communication_id, :modem_id, :modem_sn,
                                      :sim_card_id, :master, :login_name,
                                      :pass_name, :comment,
                                      :_destroy]]] if user.super_admin? ||
                                                      (access_type?('edit') ||
                                                      access_type?('new'))
  end

  private

  def shop_user?(action_name)
    user.current_shops.where(id: shop.id).exists? if access_only?(action_name)
  end

  def shop
   record
  end

  def access_info?(resource_name, action_name)
    type_access =
      user.template_accesses.where(enum_resources: { resource_name: resource_name },
        enum_actions: { action_name: action_name }).includes(:enum_resource).
          joins(enum_resource: :enum_action).pluck(:enum_type_access_id)
    if type_access.present?
      return true if type_access.join.to_i == EnumTypeAccess::ALLALOWED
      user.current_shops.where(id: shop.id).exists? if type_access.join.to_i == EnumTypeAccess::READWRITEONLY
    else
      return false
    end
  end

end
