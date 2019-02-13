class TaskPerformersController < ApplicationController
  before_action :set_task_performer, only: [:update, :destroy, :edit]
  before_action :set_task
  before_action :set_collection_user, only: [ :new, :edit, :create ]
  after_action :verify_authorized

  def new
    authorize TaskPerformer
    if @users_task_performer.present?
      @task_performer = @task.task_performers.
                           build(deadline: @task.date_execution - 1.days,
                           message: true,
                           answerable: (@task.owner_user == current_user ? true : false))
    else
      flash[:error] = "Все сотрудники отдела уже являються исполнителями!"
      redirect_to task_path(@task)
    end

  end

  def edit
    authorize @task_performer
  end

  def create
    authorize TaskPerformer
    first_performer = @task.task_performers.present? || false
    @task_performer= @task.task_performers.
                           create(permitted_attributes(TaskPerformer).merge(
                                  deadline: @task.date_execution - 1.days,
                                  answerable: (@task.owner_user == current_user ? true : false)))
    if @task_performer.save
      binding.pry
      @task.update!(status_id: Status::EXECUTION) unless first_performer
      redirect_to task_path(@task)
    else
      render 'new'
    end
  end

  def update
    authorize @task_performer
    if @task_performer.update_attributes(permitted_attributes(@task_performer))
      redirect_to task_path(@task)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @task_performer
    if @task_performer.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end

  end

  private

  def set_task_performer
    @task_performer = TaskPerformer.find(params[:id])
  end

  def set_task
  @task = Task.find(params[:task_id])
  end

  def set_collection_user
    if @task.owner_user == current_user
      @users_task_performer = Employee.employee_current_manager.
                         where.not(id: @task.task_performers.pluck(:employee_id)).
                         where.not(user_id: @task.employee.user.id).joins(:user)
    else
      structural = params[:structural_id] || 0
      @users_task_performer = Employee.employee_current_date.
                       where(manager: false, shop_id: structural).
                       where.not(id: @task.task_performers.pluck(:employee_id)).
                       where.not(id: @task.owner_user.id).joins(:user)
    end
  end



end
