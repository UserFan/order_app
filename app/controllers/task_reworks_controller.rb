class TaskReworksController < ApplicationController
  before_action :set_task_execution_rework, only: [:new, :create]
  after_action :verify_authorized

  def new
    authorize TaskRework
    @task_rework = @task_execution.task_reworks.build(user_id: current_user.id)
  end

  def create
    authorize TaskRework
    first_task_rework = @task_execution.task_reworks.present? || false
    @task = @task_execution.task_performer.task
    @task_rework = @task_execution.task_reworks.create(permitted_attributes(TaskRework))
    if @task_rework.save
      unless first_task_rework
        @task_execution.update!(task_execution:
          (@task_execution.task_performer.answerable?) ? Status::NOT_COORDINATION : Status::NOT_COORDINATION_MANAGER , completed: nil)
        @task.update!(status_id: Status::NOT_COORDINATION) if @task_execution.task_performer.answerable?
      end
      redirect_to task_path(@task)
    else
      render 'new'
    end
  end

  private

  def set_task_execution_rework
    @task_execution = TaskExecution.find(params[:task_execution_id])
  end

end
