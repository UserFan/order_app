class CashImagePolicy < ApplicationPolicy

  def permitted_attributes
    [:cashbox_id, :date_add, images: []] if user.super_admin? || user.moderator?
  end

end
