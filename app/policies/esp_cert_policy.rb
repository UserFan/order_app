class EspCertPolicy < ApplicationPolicy

  def permitted_attributes
    [:date_start_esp, :date_end_esp, :serial_num_esp, :rsa_serial,
     :date_start_rsa, :date_end_rsa] if user.super_admin? || user.moderator?
  end

end
