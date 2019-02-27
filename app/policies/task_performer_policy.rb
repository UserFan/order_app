class TaskPerformerPolicy < ApplicationPolicy

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
    record = TaskPerformer.find(item_id)
    return false if record.task_execution.present? || record.task.date_closed.present?
    user.admin?
  end

  def completed?

    !(record.task.date_closed.present?) && (user.super_admin? || (record.task.employee.user == user)) &&
    !(record.task_execution.present?)

    #
    # !(record.order.date_closed.present?) && (user.admin? || user.moderator? || user.guide?) &&
    # (record.coexecutor && !(record.execution.present?))
  end

  def executions?
      # executor = record.order.performers.find_by(coexecutor: false)
      # #binding.pry
    (user.super_admin? && !record.task.date_closed.present?) || user == record.employee.user
  end

  def permitted_attributes
    [:employee_id, :deadline, :comment, :message]
  end


end
