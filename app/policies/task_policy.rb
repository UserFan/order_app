class TaskPolicy < ApplicationPolicy
  
  def destroy?
    # return false if record.date_closed.present?
    # return false if !record.performers.empty?
    # return true if (user.moderator? || user.super_admin?) && record.can_destroy?
    false
  end

  def new_task_performers?
    (user.moderator? || user.super_admin? || user.guide? ||
     record.employee.user == user) &&
     ([Status::EXECUTION, Status::NOT_COORDINATION, Status::REVIVAL, Status::NEW].
     include?(record.status_id))
    # binding.pry
  end

  def new_task?(employee=nil)
    (user.moderator? || user.guide?) && employee.present?
  end

  def index?
    true
  end

  def new?
    (user.moderator? || user.guide?)
  end


  def create?
    true
  end

  def show?
    true
  end

  def closing?
    user.moderator? || user.super_admin? || user.guide? ||
    record.employee.user == user || !record.task_executions.present?
  end

  def show_detail?
    user.moderator? || user.super_admin? || user.guide? || record.employee.user == user
  end

  def permitted_attributes
    [:type_document_id, :date_open, :date_execution, :structural_id,
     :description, :date_closed, :employee_id, :status_id, :task_number,
     images_document: []]
  end
end
