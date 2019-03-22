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
    @task =
      Task.new(date_open: DateTime.now, employee_id: @current_employee.id,
               structural_id: @current_employee.shop_id, status_id: Status::NEW,
               date_execution: DateTime.now + 7.days)
  end

  def edit
    authorize @task
  end

  def create
    authorize Task
    @task =
      Task.new(permitted_attributes(Task).
        merge(date_open: DateTime.now, employee_id: @current_employee.id,
              date_execution: DateTime.now + 7.days, status_id: Status::NEW))
    if @task.save
      redirect_to task_path(@task)
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
      execution = task_performer.task_execution
      if execution.present? && execution.completed.nil?
        execution.update!(task_execution: Status::OFF_CONTROL,
          completed: DateTime.now,
          comment: t('.not_coordination', text: execution.comment))
      else
        task_performer.create_task_execution!(task_execution: Status::OFF_CONTROL,
                                 completed: DateTime.now,
                                 comment: t('.empty_execution'))

      end
    end
    @task.update!(status_id: @set_status, date_closed: DateTime.now) if @set_status > 0
    redirect_to task_path(@task)
  end

  def destroy
    authorize @task
    if @task.destroy
      flash[:success] = t('.success')
    else
      flash[:error] = t('.error')
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
      @caption_table =
        current_user.super_admin? ? t('.title_all') : t('.title_current')
    when 2
      @caption_table = t('.title_work')
    when 3
      @caption_table = t('.title_execution')
    when 4
      @caption_table = t('.title_coordination')
    when 5
      @caption_table = t('.agree')
    when 6
      @caption_table = t('.title_rework')
    when 7
      @caption_table = t('.title_overdue')
    when 8
      @caption_table = t('.title_new')
    when 9
      @caption_table = t('.title_signing')
    when 10
      @caption_table = t('.title_not_agree')
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

  def set_task_count(collection=nil)
    unless collection.nil?
      @signing_count = collection.execution_status(Status::SIGNING).size || 0
      @not_signed_count =
        collection.execution_status(Status::NOT_SIGNED).size || 0
      @for_closing_count = collection.task_status(Status::SIGNED).size || 0
      @agree_count = collection.task_status(Status::SIGNING).size || 0
      @new_count = collection.task_status(Status::NEW).size || 0
      @open_count = collection.task_status(Status::EXECUTION).size || 0
      @open_count = collection.task_status(Status::EXECUTION).size || 0
      @closed_count = collection.where.not(date_closed: nil).size || 0
      @tasks_count = collection.size || 0
    end
  end


  def set_index
    if (current_user.super_admin? || current_user.guide?)
      @set_tasks = Task.task_set.task_user(nil)
    else
      @set_tasks = Task.task_set.task_user(current_user)
      @not_coordination =
        @set_tasks.coordination(Status::NOT_COORDINATION_MANAGER,
                                current_user).size
      @coordination =
        @set_tasks.coordination(Status::COORDINATION_MANAGER, current_user).size
    end
    set_task_count(@set_tasks)
    @set_overdue =
      @set_tasks.where("(date_closed > date_execution)").or(@set_tasks.overdue)
    @overdue_count = @set_overdue.distinct.size
    @q = params[:overdue] ? @set_overdue.joins(:status).ransack(params[:q]) :
                            @set_tasks.joins(:status).ransack(params[:q])
    @q.sorts ||= ['date_open desc', 'created_at desc']
    @tasks = @q.result(distinct: true).paginate(page: params[:page], per_page: 5)
    set_caption_table(params[:set_caption].present? ? params[:set_caption].to_i : 1)
  end
end
