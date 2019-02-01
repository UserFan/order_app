class OrdersController < ApplicationController
  before_action :set_order, except: [ :index, :new, :create ]
  before_action :set_collection_user, only: [ :new, :edit, :create ]
  before_action :set_edit_form, only: [ :edit, :update ]
  before_action :set_index, only: [:index ]
  before_action :set_closing, only: [:closing ]
  after_action :verify_authorized

  def index
    authorize Order
  end

  def show
    authorize @order
    @performers = @order.performers
  end

  def new
    authorize Order
    @order = Order.new(date_open: DateTime.now, user_id: current_user.id,
                       date_execution: DateTime.now + 7.days,
                       status_id: Status::NEW)
    end

  def edit
    authorize @order
  end

  def create
    authorize Order
    @order = Order.new(permitted_attributes(Order).merge(date_open: DateTime.now,
              user_id: current_user.id, date_execution: DateTime.now + 7.days,
              status_id: Status::NEW))
    if @order.save
      redirect_to orders_path
    else
      render 'new'
    end
  end

  def update
    authorize @order
    if @order.update_attributes(permitted_attributes(@order))
      @order.save
      redirect_to orders_path
    else
      render 'edit'
    end
  end

  def closing
    authorize @order
    @performers = @order.performers
    @performers.find_each do |performer|
      unless performer.execution.present?
        performer.create_execution!(completed: DateTime.now, order_execution:
                   Status::OFF_CONTROL,
                   comment: 'Сведения об исполнении не были представлены')
      else
        performer.execution.update!(completed: DateTime.now, order_execution:
                   Status::OFF_CONTROL,
                   comment: "#{performer.execution.comment} (Снято с контроля без согласования)") unless performer.execution.completed.present?
      end
    end
    @order.update!(status_id: @set_status, date_closed: DateTime.now) if @set_status != 0
    redirect_to order_path(@order)
  end

  def destroy
    authorize @order

    if @order.destroy
      flash[:success] = "Заявка удачно удален."
    else
      flash[:error] = "Заявка не может буть удален. Есть связанные данные"
    end
    redirect_to orders_path
  end

  private

  def set_order
    @order ||= Order.find(params[:id])
    $send_change = 0
  end

  def set_edit_form
    @order = Order.find(params[:id])
    $send_change = 0
  end

  def set_collection_user
    @users_order =  Employee.includes(:user, :shop).
                    where(manager: true, shops: {orders_take: true})
                    .joins(:user)
    if current_user.super_admin? || current_user.guide?
      @shops = Shop.all
    else
      @shops = current_user.shops.includes(:employees).where(employees: { manager: true } )
    end
  end

  def set_caption_table(set_caption)
    case set_caption
      when 1
        @caption_table = current_user.super_admin? ? "Все заявки" : "Мои заявки"
      when 2
        @caption_table = "В работе"
      when 3
        @caption_table = "Исполненные"
      when 4
        @caption_table = "На согласовании"
      when 5
        @caption_table = "Согласованые"
      when 6
        @caption_table = "На доработке"
      when 7
        @caption_table = "Просроченные"
      when 8
        @caption_table = "Новые заявки"
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
    @set_orders = Order.includes(:category, :users, :reworks, :status, :shop)

    unless (current_user.super_admin? || current_user.moderator? || current_user.guide?)
      @set_orders =  @set_orders.where("orders.user_id = ? OR employees.user_id = ? OR employees_performers.user_id = ?",
                        current_user, current_user, current_user).left_outer_joins(:employee, performers: :employee)
    end
    @orders_for_closing = @set_orders.where("date_closed is null and status_id = ?",
                          Status::COORDINATION).size
    @orders_agree = @set_orders.where("date_closed is null and status_id = ?",
                          Status::AGREE).size
    @orders_new = @set_orders.where(status_id: Status::NEW).size

    @orders_coordination = @set_orders.where("date_closed is null and
              status_id = ?", Status::AGREE).size

    @orders_for_closing = @set_orders.where("date_closed is null and
                          status_id = ?", Status::COORDINATION).
                          distinct.size #if @set_orders.where(user_id: current_user)
    @orders_agree = @set_orders.where("date_closed is null and status_id = ?", Status::AGREE).size #if @set_orders.where(user_id: current_user)

    @set_orders_overdue =
        @set_orders.where("(date_closed > date_execution)").or(@set_orders).
                    where("(date_closed IS NULL AND date_execution < ?) OR
                           (executions.completed IS NULL AND performers.deadline < ?)
                           OR (executions.completed > date_execution) OR
                           (executions.completed > performers.deadline)",
                           Date.today, Date.today).left_outer_joins(:executions)

    params[:overdue] ? @q = @set_orders_overdue.ransack : @q = @set_orders.ransack(params[:q])
    set_caption_table(params[:set_caption].nil? ? 1 : (params[:set_caption].to_i))
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @orders = @q.result(disinct: true)
    @orders_closed = @set_orders.where.not(date_closed: nil).size
    @orders_open = @set_orders.where("date_closed is null and status_id = ?", Status::EXECUTION).size
    @orders_not_coordination =@set_orders.where("date_closed is null and status_id = ?",
                                Status::NOT_COORDINATION).distinct.size
    @orders_count = @set_orders.size
    @orders_overdue =  @set_orders_overdue.size
  end
end
