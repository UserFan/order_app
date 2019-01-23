class PerformerPolicy < ApplicationPolicy

  def new?
    #user.admin? || user.moderator? || user.guide?
    #binding.pry
    #|| record.order.employee.user == user
    true
  end

  def create?
    new?
  end

  def delete?(item_id)
    record = Performer.find(item_id)
    return false if record.execution.present? || record.order.date_closed.present?
    user.admin?
  end

  def completed?

    !(record.order.date_closed.present?) && (user.super_admin? || (record.order.employee.user == user)) &&
    !(record.execution.present?)

    #
    # !(record.order.date_closed.present?) && (user.admin? || user.moderator? || user.guide?) &&
    # (record.coexecutor && !(record.execution.present?))
  end

  def executions?
      # executor = record.order.performers.find_by(coexecutor: false)
      # #binding.pry
    (user.super_admin? && !record.order.date_closed.present?) || user == record.employee.user
  end

  def permitted_attributes
    [:employee_id, :deadline, :comment, :message, :hard_ratio_average]
  end


end
