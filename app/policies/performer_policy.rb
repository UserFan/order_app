class PerformerPolicy < ApplicationPolicy

  def delete?(item_id)
    record = Performer.find(item_id)
    return false if record.execution.present? || order_closed?
    true
  end

  def completed?
    !(order_closed?) && (user.admin? || user.moderator? || user.guide?)
  end

  def executions?
    executor = record.order.performers.find_by(coexecutor: false)
    #binding.pry
    (user.admin? && !order_closed?) || user == record.user && !executor.execution.present?
  end

private

  def order_closed?
    record.order.date_closed.present?
  end
end
