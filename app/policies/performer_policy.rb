class PerformerPolicy < ApplicationPolicy

  def delete?(item_id)
    record = Performer.find(item_id)
    return false if record.execution.present? || record.order.date_closed.present?
    true
  end

  def completed?
    !(record.order.date_closed.present?) && (user.admin? || user.moderator? || user.guide?)
  end

  def executions?
    executor = record.order.performers.find_by(coexecutor: false)
    #binding.pry
    (user.admin? && !record.order.date_closed.present?) || user == record.user && !executor.execution.present?
  end


end
