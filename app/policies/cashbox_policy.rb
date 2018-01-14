class CashboxPolicy < ApplicationPolicy

  def permitted_attributes
    [:shop_id, :display_id, :display_sn, :system_unit_id, :system_unit_sn, :keyboard_id,
     :keyboard_sn, :display_client_id, :display_client_sn, :stabilizer_id, :stabilizer_sn,
     :apc_id, :apc_sn, :scaner_id, :scaner_sn, :bank_unit_id, :terminal_sn, :fiscal_id,
     :fiscal_sn, :organization_unit_id, :cashbox_photos_id, :comment] if user.super_admin? || user.moderator?
  end

end
