class TaskExecutionPolicy < ApplicationPolicy

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

  def coordination_master?
    (record.task_performer.task_performer.user == user) &&
    (!(task_closed?) && (record.completed.nil?))
  end

  def coordination?
    (record.task.employee.user == user) &&
     (!(task_closed?) && (record.completed.nil?))
    #binding.pry
  end

  def remove_control?
    (user.super_admin? || user.moderator? || user.guide?)
  end

  def rework?
    (record.task.employee.user == user) &&
    (!(task_closed?) && (record.completed.nil?) && !(record.task_execution == Status::NOT_SIGNED))
  end

  def rework_master?
    (record.task_performer.task_performer.user == user) &&
    (!(task_closed?) && (record.completed.nil?) && !(record.task_execution == Status::NOT_COORDINATION_MANAGER))
  end

  def comment?
    (user.super_admin? || user.moderator? || user.guide? ||
     user == record.task_performer.employee.user || record.task.owner_user == user) &&
    (!(task_closed?) && (record.completed.nil?))
  end

  def destroy?
    user.super_admin? && !(task_closed?)
  end


  def permitted_attributes
    [:task_performer_id, :comment, :task_execution, :completed, :manager_id,
     images_document: []]
  end

  private

  def task_closed?
    record.task_performer.task.date_closed.present?
  end

end
