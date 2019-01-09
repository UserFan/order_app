class ShopPolicy < ApplicationPolicy


  def destroy?
    return false if record.closed.present?
    user.moderator? || user.super_admin?
  end

  def index?
    true
  end

  def show_unit?
    !record.structural_unit
  end

  def import_version?
    user.super_admin?
  end

  def list?
    user.moderator? || user.super_admin? ||
    user.guide? || record.user == user
  end

  def show?
    user.moderator? || user.super_admin? ||
    user.guide? || record.user == user
  end

  def show_specialty?
    import_version?
  end

  def version_update?
    import_version?
  end

  def export_shops?
    import_version?
  end

  def service_show?
    import_version?
  end

  def permitted_attributes
    [:name, :email, :address, :type_id, :photo, :closed,
     cashboxes_attributes: [:id, :shop_id, :display_id, :display_sn,
                            :system_unit_id, :system_unit_sn, :keyboard_id,
                            :keyboard_sn, :display_client_id, :display_client_sn,
                            :stabilizer_id, :stabilizer_sn,:apc_id, :apc_sn,
                            :scaner_id, :scaner_sn, :bank_unit_id, :terminal_sn,
                            :fiscal_id, :fiscal_sn, :organization_unit_id,
                            :cashbox_photos_id, :ip_cash, :comment, :_destroy,
     cash_images_attributes: [:id, :cashbox_id, :date_add, :_destroy, images: []]],
     computers_attributes: [:id, :shop_id, :display_id, :display_sn, :system_unit_id,
                            :system_unit_sn, :keyboard_id, :keyboard_sn,
                            :commouse_id, :commouse_sn, :stabilizer_id, :stabilizer_sn,
                            :printer_id, :printer_sn, :teamview_id, :ip_address, :comment, :_destroy],
     shop_weighers_attributes: [:id, :shop_id, :weigher_id, :weigher_sn, :ip_address, :comment, :_destroy],
     shop_communications_attributes: [:id, :shop_id, :router_id, :router_sn, :_destroy,
     item_communications_attributes: [:id, :shop_communication_id, :provider_id, :communication_id,
                                      :modem_id, :modem_sn, :sim_card_id, :master,
                                      :login_name, :pass_name, :comment, :_destroy]]] if user.super_admin? || user.moderator?
  end

end
