class PerformerPolicy < ApplicationPolicy


  def executions?
    executor = record.order.performers.find_by(coexecutor: false)
    #binding.pry
    user.admin? && !record.order.date_closed.present? || user == record.user && !record.date_close_performance.present? &&
                   !executor.execution.present?
  end
end
