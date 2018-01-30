class ShopPolicy < ApplicationPolicy


  def destroy?
    return false if record.closed.present?
    user.moderator? || user.super_admin?
  end


  def permitted_attributes
    [:name, :address, :type_id, :user_id, :photo, :closed,
     cashboxes_attributes: [:id, :shop_id, :display_id, :display_sn,
                            :system_unit_id, :system_unit_sn, :keyboard_id,
                            :keyboard_sn, :display_client_id, :display_client_sn,
                            :stabilizer_id, :stabilizer_sn,:apc_id, :apc_sn,
                            :scaner_id, :scaner_sn, :bank_unit_id, :terminal_sn,
                            :fiscal_id, :fiscal_sn, :organization_unit_id,
                            :cashbox_photos_id, :comment, :_destroy,
     cash_images_attributes: [:id, :cashbox_id, :date_add, :_destroy, images: []]],
     computers_attributes: [:id, :shop_id, :display_id, :display_sn, :system_unit_id,
                            :system_unit_sn, :keyboard_id, :keyboard_sn,
                            :commouse_id, :commouse_sn, :stabilizer_id, :stabilizer_sn,
                            :printer_id, :printer_sn, :teamview_id, :ip_address, :comment, :_destroy],
     shop_weighers_attributes: [:id, :shop_id, :weigher_id, :weigher_sn, :ip_address, :comment, :_destroy],
     shop_communications_attributes: [:id, :shop_id, :router_id, :router_sn, :_destroy,
     item_communications_attributes: [:id, :shop_communication_id, :provider_id, :communication_id,
                                      :modem_id, :modem_sn, :simphone_number, :sim_number,
                                      :login_name, :pass_name, :comment, :_destroy]]] if user.super_admin? || user.moderator?
  end

end
