class TasksController < ApplicationController
  before_action :set_structural
  before_action :set_task, except: [ :index, :new, :create ]
  before_action :set_edit_form, only: [ :edit, :update ]
  before_action :set_index, only: [:index ]
  before_action :set_closing, only: [:closing ]

  after_action :verify_authorized

  def index
    authorize Task
  end

  def show
    authorize @task
    @task_performers = @task.task_performers.where(answerable: true)
    @task_performers_slave = @task.task_performers.where(answerable: false)
  end

  def new
    authorize Task
    @task = Task.new(date_open: DateTime.now, employee_id: @current_employee.id,
                       structural_id: @current_employee.shop_id,
                       date_execution: DateTime.now + 7.days,
                       status_id: Status::NEW)
    end

  def edit
    authorize @task
  end

  def create
    authorize Task
    @task = Task.new(permitted_attributes(Task).merge(
                      date_open: DateTime.now,
                      employee_id: @current_employee.id,
                      date_execution: DateTime.now + 7.days,
                      status_id: Status::NEW))
    if @task.save
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  def update
    authorize @task
    if @task.update_attributes(permitted_attributes(@task))
      @task.save
      redirect_to tasks_path
    else
      render 'edit'
    end
  end

  def closing
    authorize @task
    @task_performers = @task.task_performers
    @task_performers.find_each do |task_performer|
      unless task_performer.task_execution.present?
        task_performer.create_task_execution!(completed: DateTime.now, task_execution:
                   Status::OFF_CONTROL,
                   comment: 'Сведения об исполнении не были представлены')
      else
        task_performer.task_execution.update!(completed: DateTime.now, task_execution:
                   Status::OFF_CONTROL,
                   comment: "#{task_performer.task_execution.comment} (Снята с контроля без согласования)") unless task_performer.task_execution.completed.present?
      end
    end
    @task.update!(status_id: @set_status, date_closed: DateTime.now) if @set_status != 0
    redirect_to task_path(@task)
  end

  def destroy
    authorize @task

    if @task.destroy
      flash[:success] = "Контрольная карточка удачно удалена."
    else
      flash[:error] = "Контрольная карточка не может буть удалена. Есть связанные данные"
    end
    redirect_to tasks_path
  end

  private

  def set_task
    @task ||= Task.find(params[:id])
  end

  def set_structural
    if current_user.super_admin?
      @structural = Shop.all
    else
      @structural = Shop.shop_employees(current_user.id)
      @current_employee = Employee.employee_current(current_user.id)
    end
  end

  def set_edit_form
    @task = Task.find(params[:id])
  end

  def set_caption_table(set_caption)
    case set_caption
      when 1
        @caption_table = current_user.super_admin? ? "Все карточки" : "Мои карточки"
      when 2
        @caption_table = "В работе"
      when 3
        @caption_table = "Исполненные"
      when 4
        @caption_table = "На согласовании"
      when 5
        @caption_table = "Согласованные"
      when 6
        @caption_table = "На доработке"
      when 7
        @caption_table = "Просроченные"
      when 8
        @caption_table = "Новые"
      else
        @caption_table = ""
    end
  end

  def set_closing
    case (params[:close]).to_i
      when Status::COMPLETED
        @set_status = Status::COMPLETED
      when Status::PART_COMPLETED
        @set_status = Status::PART_COMPLETED
      when Status::NOT_COMPLETED
        @set_status = Status::NOT_COMPLETED
      when Status::OFF_CONTROL
        @set_status = Status::OFF_CONTROL
      else
        @set_status = 0
    end
  end

  def set_index
    unless (current_user.super_admin? || current_user.guide?)
      @set_tasks = Task.taks_set.tasks_user(current_user)
      @tasks_not_coordination = @set_tasks.coordination(
                                  Status::NOT_COORDINATION_MANAGER,
                                  current_user).size

      @tasks_coordination = @set_tasks.coordination(
                              Status::COORDINATION_MANAGER,
                              current_user).size
    else
      @set_tasks = Task.taks_set
    end


    @tasks_signing = @set_tasks.execution_status(Status::SIGNING).size
    @tasks_not_signed = @set_tasks.execution_status(Status::NOT_SIGNED).size
    @tasks_for_closing = @set_tasks.task_status(Status::SIGNED).size
    @tasks_agree = @set_tasks.task_status(Status::SIGNING).size
    @tasks_new = @set_tasks.task_status(Status::NEW).size
    @tasks_open = @set_tasks.task_status(Status::EXECUTION).size
    @tasks_open = @set_tasks.task_status(Status::EXECUTION).size
    @tasks_closed = @set_tasks.where.not(date_closed: nil).size
    @tasks_count = @set_tasks.size


    # @tasks_not_coordination = @set_tasks.where(date_closed: nil).
    #                       where(task_executions: { task_execution: Status::NOT_COORDINATION_MANAGER, manager_id: current_user }).size
    # @tasks_coordination = @set_tasks.where(date_closed: nil).
    #                       where(task_executions: { task_execution: Status::COORDINATION_MANAGER, manager_id: current_user }).size
    # @tasks_for_closing = @set_tasks.where(date_closed: nil, status_id: Status::SIGNED).size
    # @tasks_signing = @set_tasks.where(date_closed: nil).
    #                       where(task_executions: { task_execution: Status::SIGNING }).size
    # @tasks_not_signed = @set_tasks.where(date_closed: nil).
    #                       where(task_executions: { task_execution: Status::NOT_SIGNED }).size
    # @tasks_agree = @set_tasks.where(date_closed: nil, status_id: Status::SIGNING).size
    # @tasks_new = @set_tasks.where(status_id: Status::NEW).size

    @set_tasks_overdue =
        @set_tasks.where("(date_closed > date_execution)").or(@set_tasks).
                    where("(date_closed IS NULL AND date_execution < ?) OR
                           (task_executions.completed IS NULL AND task_performers.deadline < ?)
                           OR (task_executions.completed > date_execution) OR
                           (task_executions.completed > task_performers.deadline)",
                           Date.today, Date.today)


    # @set_tasks_overdue =
    #     @set_tasks.where("(date_closed > date_execution)").or(@set_tasks).
    #                 where("(date_closed IS NULL AND date_execution < ?)",
    #                 Date.today).includes(:shop, :status, :type_document)
    #                 # OR
                    #        (executions.completed IS NULL AND performers.deadline < ?)
                    #        OR (executions.completed > date_execution) OR
                    #        (executions.completed > performers.deadline)",
                    #        Date.today, Date.today).left_outer_joins(performers: :execution).includes(:shop, :status, :category)

    params[:overdue] ? @q = @set_tasks_overdue.joins(:status, :shop).ransack : @q = @set_tasks.joins(:status, :shop).ransack(params[:q])
    set_caption_table(params[:set_caption].nil? ? 1 : (params[:set_caption].to_i))
    @q.sorts = ['statuses_name_asc shop_name asc', 'created_at desc'] if @q.sorts.empty?
    @tasks = @q.result(distinct: true).paginate(page: params[:page], per_page: 5)
    @tasks_overdue = @set_tasks_overdue.size
  end
end
