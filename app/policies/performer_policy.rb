class PerformerPolicy < ApplicationPolicy
  
  def delete?(item_id)
    record = Performer.find(item_id)
    return false if record.execution.present? || record.order.date_closed.present?
    true
  end

  def executions?
    executor = record.order.performers.find_by(coexecutor: false)
    #binding.pry
    user.admin? && !record.order.date_closed.present? || user == record.user && !record.date_close_performance.present? &&
                   !executor.execution.present?
  end
end
