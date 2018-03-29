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
    (user.super_admin? || user.moderator? || user.guide?) &&
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
