class EspCertPolicy < ApplicationPolicy

  def export_xls?
    user.admin?
  end

  def permitted_attributes
    [:date_start_esp, :date_end_esp, :serial_num_esp, :rsa_serial,
     :date_start_rsa, :date_end_rsa] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

end
