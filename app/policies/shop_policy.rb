class ShopPolicy < ApplicationPolicy


  def destroy?
    return false if record.closed.present?
    user.moderator? || user.super_admin?
  end


  def permitted_attributes
    [:name, :address, :type_id, :user_id, :photo, :closed] if user.super_admin? || user.moderator?
  end

end
