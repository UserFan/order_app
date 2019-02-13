class TaskExecutionsController < ApplicationController
  before_action :set_task_perform_execution, only: [:new, :edit, :create]
  before_action :set_task_execution, only: [:update, :destroy, :show, :coordination]
  after_action :verify_authorized

  def new
    authorize TaskExecution
  end

  def show
    authorize @task_execution
  end

  def edit
    authorize @task_execution
  end

  def create
    authorize TaskExecution
    @task_execution_new = @task_performer.create_task_execution(permitted_attributes(TaskExecution))
    if @task_execution_new.save
      unless [Status::OFF_CONTROL].include?(@task_execution_new.task_execution)
        @task.update!(status_id: Status::COORDINATION) if @task_performer.answerable?
      end
      redirect_to task_path(@task_performer.task)
    else
      render 'new'
    end
  end

  def update
    authorize @task_execution
    if @task_execution.update_attributes(permitted_attributes(@task_execution))
     redirect_to order_path(@task_execution.task)
    else
      render 'new'
    end
  end

  def coordination
    authorize @task_execution
    @task = @task_execution.task_performer.task
    @task.update!(status_id: Status::AGREE) if  @task_execution.task_performer.answerable?
    if @task_execution.update_attributes(completed: DateTime.now, task_execution:
      @task_execution.task_performer.answerable? ? Status::AGREE : Status::AGREE_MANAGER)
      respond_to do |format|
         format.html { redirect_to task_path(@task) }
         format.json { head :no_content }
         format.js   { render layout: false }
      end
    end
  end

  def remove_control
    authorize TaskExecution
    @task_performer = TaskPerformer.find(params[:task_performer_id])
    @task = @task_performer.task
    @task_execution = @task_performer.build_task_execution(completed: DateTime.now,
                 task_execution: Status::OFF_CONTROL,
                 comment: 'Снято с контроля(без исполнения)!')
    if @task_execution.save
      #binding.pry
      #@performer.update!(date_close_performance: DateTime.now) unless @performer.date_close_performance.present?
      redirect_to task_path(@task)
    end
  end


  def destroy
    authorize @task_execution
    @task = @task_execution.task_performer.task
    if @task_execution.destroy
      @task.update!(status_id: Status::EXECUTION)
      #@task_execution.performer.update!(date_close_performance: nil)
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to task_path(@task_execution.task_performer.task)
  end

  private

  def set_task_perform_execution
    @task_performer = TaskPerformer.find(params[:task_performer_id])
    structural = (params[:answerable_structural]).to_i || 0
    @task = @task_performer.task
    @task_execution = @task_performer.task_execution || @task_performer.build_task_execution(task_execution: (structural > 0) ? Status::COORDINATION_MANAGER : Status::COORDINATION)
  end

  def set_task_execution
    @task_execution = TaskExecution.find(params[:id])
  end



end
