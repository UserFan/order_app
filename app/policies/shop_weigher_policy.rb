class ShopWeigherPolicy < ApplicationPolicy

  def permitted_attributes
    [:shop_id, :weigher_id, :weigher_sn, :ip_address, :comment] if user.super_admin? || user.moderator?
  end

end
