class OrderPolicy < ApplicationPolicy


  def destroy?
    return false if record.date_closed.present?
    user.moderator? || user.super_admin?
  end

  def index?
    true
  end

  def show?
    true
  end


  def permitted_attributes
    [:category_id, :date_open, :date_execution, :shop_id, :short_descript,
     :description,:date_closed, :user_id, :status_id, photos: [],
     performers_attributes: [:id, :order_id, :user_id, :coexecutor, :date_performance,
                             :date_close_performance, :message, :comment, :_destroy]] if user.super_admin? || user.moderator?
  end

end
