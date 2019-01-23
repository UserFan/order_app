class ExecutionPolicy < ApplicationPolicy

  def new?
    true
  end

  def index?
    true
  end

  def create?
    new?
  end

  def show?
    new?
  end

  def update?
    new?
  end

  def edit?
    new?
  end

  def coordination?
    #binding.pry
    (user.super_admin? || user.moderator? || user.guide? || (record.order.owner_user == user)) &&
    (!(order_closed?) && (record.completed.nil?))
  end

  def remove_control?
    (user.super_admin? || user.moderator? || user.guide?)
  end

  def rework?
    (user.super_admin? || user.moderator? || user.guide? || (record.order.owner_user == user)) &&
    (!(order_closed?) && (record.completed.nil?) && !(record.order_execution == Status::NOT_COORDINATION))
  end

  def comment?
    (user.super_admin? || user.moderator? || user.guide? ||
     user == record.performer.employee.user || record.order.owner_user == user ||
     user == record.order.employee.user) &&
    (!(order_closed?) && (record.completed.nil?))
  end

  def destroy?
    user.super_admin? && !(order_closed?)
  end


  def permitted_attributes
    [:performer_id, :comment, :order_execution, :completed, images: []]
  end

  private

  def order_closed?
    record.performer.order.date_closed.present?
  end

end
