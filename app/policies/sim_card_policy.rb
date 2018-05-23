class SimCardPolicy < ApplicationPolicy

  def permitted_attributes
    [:sim_number, :simphone_number, :provider_id] if user.super_admin? || user.moderator?
  end

end
