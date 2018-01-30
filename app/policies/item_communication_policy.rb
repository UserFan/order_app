class ItemCommunicationPolicy < ApplicationPolicy

  def permitted_attributes
    [:shop_communication_id, :modem_id, :modem_sn, :provider_id, :communication_id,
     :simphone_number, :sim_number, :master, :login_name, :pass_name, :comment] if user.super_admin? || user.moderator?
  end

end
