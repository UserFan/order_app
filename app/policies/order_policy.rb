class OrderPolicy < ApplicationPolicy


  def destroy?
    return false if record.date_closed.present?
    return false if !record.performers.empty?
    return true if (user.moderator? || user.super_admin?) && record.can_destroy?
    false
  end

  def new_performers?
    (user.moderator? || user.super_admin? || user.guide? ||
     record.employee.user == user) &&
     ([Status::EXECUTION, Status::NOT_COORDINATION, Status::REVIVAL, Status::NEW].
     include?(record.status_id))
    # binding.pry
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
    #true
    #user.moderator? || user.super_admin? || user.guide?
    #|| record.employee.user == user || record.owner_user == user
    #true
  end

  def closing?
    user.moderator? || user.super_admin? || user.guide? ||
    record.employee.user == user || !record.executions.present?

  end

  def show_detail?
    user.moderator? || user.super_admin? || user.guide? || record.employee.user == user
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
