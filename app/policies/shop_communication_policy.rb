class ShopCommunicationPolicy < ApplicationPolicy

  def permitted_attributes
    [:shop_id, :router_id, :router_sn] if user.super_admin? || user.moderator?
  end

end
