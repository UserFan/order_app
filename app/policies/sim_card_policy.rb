class SimCardPolicy < ApplicationPolicy

  def sim_card_log?
    show?
  end

  def permitted_attributes
    [:sim_number, :simphone_number, :provider_id] if user.super_admin? || user.moderator?
  end

end
