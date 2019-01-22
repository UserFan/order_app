class OrderPolicy < ApplicationPolicy


  def destroy?
    return false if record.date_closed.present?
    return false if !record.performers.empty?
    user.moderator? || user.super_admin?
    record.can_destroy?
  end

  def index?
    true
  end

  def new?
    true
  end


  def create?
    true
  end

  def show?
    true
  end

  def for_closing?
    user.moderator? || user.super_admin? || user.guide? || record.employee.user == user
  end

  def closing?
    user.moderator? || user.super_admin? || user.guide? || record.employee.user == user
  end

  def show_detail?
    user.moderator? || record.employee.user == user
  end

  def permitted_attributes
    [:category_id, :date_open, :date_execution, :shop_id, :employee_id,
     :description, :date_closed, :user_id, :status_id, :order_number,
     photos: []]
  end

  # def permitted_attributes
  #   [:category_id, :date_open, :date_execution, :shop_id, :short_descript,
  #    :description,:date_closed, :user_id, :status_id, photos: [],
  #    performers_attributes: [:id, :order_id, :user_id, :coexecutor, :date_performance,
  #                            :date_close_performance, :message, :comment, :_destroy]] if user.super_admin? || user.moderator?
  # end

end
