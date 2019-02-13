class TasksController < ApplicationController
  before_action :set_task, except: [ :index, :new, :create ]
  before_action :set_edit_form, only: [ :edit, :update ]
  before_action :set_structural
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
    # @performers = @task.performers
    # @performers.find_each do |performer|
    #   unless performer.execution.present?
    #     performer.create_execution!(completed: DateTime.now, order_execution:
    #                Status::OFF_CONTROL,
    #                comment: 'Сведения об исполнении не были представлены')
    #   else
    #     performer.execution.update!(completed: DateTime.now, order_execution:
    #                Status::OFF_CONTROL,
    #                comment: "#{performer.execution.comment} (Снята с контроля без согласования)") unless performer.execution.completed.present?
    #   end
    # end
    # @task.update!(status_id: @set_status, date_closed: DateTime.now) if @set_status != 0
    # redirect_to order_path(@task)
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
    @set_tasks = Task.includes(:type_document, :status, :shop, :employee)

    unless (current_user.super_admin? || current_user.moderator? || current_user.guide?)
      # @set_tasks =  @set_tasks.where("tasks.user_id = ? OR employees.user_id = ? OR employees_performers.user_id = ?",
      #                   current_user, current_user, current_user).left_outer_joins(:employee, performers: :employee).distinct

      @set_tasks = Task.where(employee_id: @current_employee.id).includes(:shop, :status, :type_document, :employee).distinct

      # .or(Task.where("employees_performers.user_id=?", current_user)).
      #               left_outer_joins(:employee, performers: :employee).
      #               includes(:shop, :status, :category).distinct
    end
    @tasks_for_closing = @set_tasks.includes(:shop, :status, :type_document, :user).
                          where("date_closed is null and status_id = ?",
                          Status::COORDINATION).size
    @tasks_agree = @set_tasks.includes(:shop, :status, :type_document, :user).where("date_closed is null and status_id = ?",
                          Status::AGREE).size
    @tasks_new = @set_tasks.includes(:shop, :status, :type_document, :user).where(status_id: Status::NEW).size

    @tasks_coordination = @set_tasks.includes(:shop, :status, :type_document, :user).where("date_closed is null and
              status_id = ?", Status::AGREE).size

    @tasks_for_closing = @set_tasks.includes(:shop, :status, :type_document, :user).where("date_closed is null and
                          status_id = ?", Status::COORDINATION).
                          distinct.size #if @set_tasks.where(user_id: current_user)
    @tasks_agree = @set_tasks.includes(:shop, :status, :type_document, :user).where("date_closed is null and status_id = ?", Status::AGREE).size #if @set_tasks.where(user_id: current_user)

    @set_tasks_overdue =
        @set_tasks.where("(date_closed > date_execution)").or(@set_tasks).
                    where("(date_closed IS NULL AND date_execution < ?)",
                    Date.today).includes(:shop, :status, :type_document, :user)


                    # OR
                    #        (executions.completed IS NULL AND performers.deadline < ?)
                    #        OR (executions.completed > date_execution) OR
                    #        (executions.completed > performers.deadline)",
                    #        Date.today, Date.today).left_outer_joins(performers: :execution).includes(:shop, :status, :category)

    params[:overdue] ? @q = @set_tasks_overdue.joins(:status, :shop).ransack : @q = @set_tasks.joins(:status, :shop).ransack(params[:q])
    set_caption_table(params[:set_caption].nil? ? 1 : (params[:set_caption].to_i))
    @q.sorts = ['statuses_name_asc shop_name asc', 'created_at desc'] if @q.sorts.empty?
    @tasks = @q.result(distinct: true).paginate(page: params[:page], per_page: 5)
    @tasks_closed = @set_tasks.includes(:shop, :status, :type_document, :user).where.not(date_closed: nil).size
    @tasks_open = @set_tasks.includes(:shop, :status, :type_document, :user).where("date_closed is null and status_id = ?", Status::EXECUTION).size
    @tasks_not_coordination =@set_tasks.includes(:shop, :status, :type_document, :user)
                                        .where("date_closed is null and status_id = ?",
                                        Status::NOT_COORDINATION).distinct.size
    @tasks_count = @set_tasks.includes(:shop, :status, :type_document, :user).size
    @tasks_overdue = @set_tasks_overdue.includes(:shop, :status, :type_document, :user).size

    # params[:overdue] ? @q = @set_tasks_overdue.joins(:status, :shop).ransack : @q = @set_tasks.joins(:status, :shop).ransack(params[:q])
    # set_caption_table(params[:set_caption].nil? ? 1 : (params[:set_caption].to_i))
    # @q.sorts = ['statuses_name_asc shop_name asc', 'created_at desc'] if @q.sorts.empty?
    # @tasks = @q.result(distinct: true).paginate(page: params[:page], per_page: 5)
    # @tasks_closed = @set_tasks.includes(:shop, :status, :category, :employee, :performers).where.not(date_closed: nil).size
    # @tasks_open = @set_tasks.includes(:shop, :status, :category, :employee, :performers).where("date_closed is null and status_id = ?", Status::EXECUTION).size
    # @tasks_not_coordination =@set_tasks.includes(:shop, :status, :category, :employee, :performers).where("date_closed is null and status_id = ?",
    #                             Status::NOT_COORDINATION).distinct.size
    # @tasks_count = @set_tasks.includes(:shop, :status, :category, :employee, :performers).size
    # @tasks_overdue = @set_tasks_overdue.includes(:shop, :status, :category, :employee, :performers).size

  end
end
