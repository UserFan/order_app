class EspPolicy < ApplicationPolicy

  def permitted_attributes
    [:carrier_type_id, :kpp] if user.super_admin? || user.moderator?
  end

end
