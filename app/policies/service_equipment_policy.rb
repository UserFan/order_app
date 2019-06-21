class ServiceEquipmentPolicy < ApplicationPolicy

  def permitted_attributes
    [:date_service, :equipment_type_id, :shop_id, :amount,
     :description] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

end
