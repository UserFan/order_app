class CostEquipmentPolicy < ApplicationPolicy

  def permitted_attributes
    [:date_cost, :cost_type_id, :description] if user.super_admin? || user.moderator?
  end

end
