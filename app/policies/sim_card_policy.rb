class SimCardPolicy < ApplicationPolicy

  def sim_card_log?
    show?
  end

  def permitted_attributes
    [:sim_number, :simphone_number, :provider_id,
     :traffic, :update_traffic] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

end
