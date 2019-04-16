class ServiceEquipmentPolicy < ApplicationPolicy

  def permitted_attributes
    [:date_service, :equipment_type_id, :shop_id, :amount, :description] if user.super_admin? || user.moderator?
  end

end
