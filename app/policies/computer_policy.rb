class ComputerPolicy < ApplicationPolicy

  def permitted_attributes
    [:shop_id, :display_id, :display_sn, :system_unit_id, :system_unit_sn,
    :keyboard_id, :keyboard_sn, :commouse_id, :commouse_sn, :stabilizer_id,
    :stabilizer_sn, :printer_id, :printer_sn, :teamview_id, :ip_address, :comment] if user.super_admin? || user.moderator?
  end

end
