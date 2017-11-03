class OrderPolicy < ApplicationPolicy


  def destroy?
    return false if record.date_closed.present?
    user.moderator? || user.super_admin?
  end


  def permitted_attributes
    [:category_id, :date_open, :shop_id, :short_descript, :description, :date_closed, :user_id, :status_id] if user.super_admin? || user.moderator?
  end

end
