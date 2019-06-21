class EmployeePolicy < ApplicationPolicy

  def edit?
    user.super_admin? || (access_type?('edit') && !record.work_end_date.present?)
  end

  def permitted_attributes
    [:shop_id, :user_id, :work_start_date, :work_end_date, :manager,
     :temporary, :position_id] if user.super_admin?
  end

end
