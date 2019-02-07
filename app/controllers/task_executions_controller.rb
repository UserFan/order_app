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
    @task_execution_new = @task_performer.create_execution(permitted_attributes(Execution))
    if @task_execution_new.save
      unless [Status::OFF_CONTROL].include?(@task_execution_new.order_execution)
        @task.update!(status_id: Status::COORDINATION)
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
    @task = @task_execution.performer.order
    @task.update!(status_id: Status::AGREE)
    if @task_execution.update_attributes(completed: DateTime.now, order_execution: Status::AGREE)
      respond_to do |format|
         format.html { redirect_to order_path(@task) }
         format.json { head :no_content }
         format.js   { render layout: false }
      end
    end
  end

  def remove_control
    authorize Execution
    @performer = Performer.find(params[:performer_id])
    @task = @performer.order
    @task_execution = @performer.build_execution(completed: DateTime.now,
                 order_execution: Status::OFF_CONTROL,
                 comment: 'Снято с контроля(без исполнения)!')
    if @task_execution.save
      #binding.pry
      #@performer.update!(date_close_performance: DateTime.now) unless @performer.date_close_performance.present?
      redirect_to order_path(@task)
    end
  end


  def destroy
    authorize @task_execution
    @task = @task_execution.performer.order
    if @task_execution.destroy
      @task.update!(status_id: Status::EXECUTION)
      #@task_execution.performer.update!(date_close_performance: nil)
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to order_path(@task_execution.performer.order)
  end

  private

  def set_task_perform_execution
    @task_performer = TaskPerformer.find(params[:task_performer_id])
    @task = @task_performer.task
    @task_execution = @task_performer.task_execution || @task_performer.build_task_execution(task_execution: Status::COORDINATION)
  end

  def set_task_execution
    @task_execution = TaskExecution.find(params[:id])
  end



end
