class ShopPolicy < ApplicationPolicy

  def permitted_attributes
    [:name, :address, :type_id, :user_id, :photo] if user.super_admin? || user.moderator?
  end

end
