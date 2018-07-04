class OrdersController < ApplicationController
  before_action :set_order, except: [ :index, :new, :create ]
  before_action :set_edit_form, only: [ :edit, :update ]
  before_action :set_index, only: [:index ]
  before_action :set_closing, only: [:closing ]
  after_action :verify_authorized

  def index
    authorize Order
  end

  def show
    authorize @order
    @executor = @order.performers.where(coexecutor: false)
    @coexecutor = @order.performers.where(coexecutor: true)
  end

  def new
    authorize Order
    @order = OrderForm.new(Order.new)
  end

  def edit
    authorize @order
  end

  def create
    authorize Order
    @order = OrderForm.new(Order.new)
    if @order.validate(params[:order])
      @order.save
      redirect_to orders_path
    else
      render 'new'
    end
  end

  def update

    authorize @order
    if @order.validate(params[:order])
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
      performer.create_execution!(completed: DateTime.now, order_execution:
                 Status::OFF_CONTROL,
                 comment: 'Сведения об исполнении не были представлены') unless performer.execution.present?
      OrderMailer.with(user: performer.user, order: @order,
        send_type: 'close_order').order_send_mail_to_user.deliver_later(wait: 15.seconds)
    end
    @order.update!(status_id: @set_status, date_closed: DateTime.now) if @set_status != 0
    OrderMailer.with(user: @order.control_user, order: @order,
      send_type: 'close_order').order_send_mail_to_user.deliver_later(wait: 10.seconds)
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
    @order = OrderForm.new(Order.find(params[:id]))
    $send_change = 0
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
    if current_user.super_admin? || current_user.moderator?
      @q = Order.includes(:shop, :category, :status, :users, :performers,
                          :executions, :reworks).ransack(params[:q])
      @orders_closed = Order.includes(:shop, :category, :status, :users, :performers,
                          :executions, :reworks).where.not(date_closed: nil).size
      @orders_open = Order.includes(:shop, :category, :status, :users, :performers,
                          :executions, :reworks).where("date_closed is null and status_id = ?", Status::EXECUTION).size
      @orders_overdue = Order.includes(:shop, :category, :status, :users, :performers,
                          :executions, :reworks).where("(date_closed > date_execution) OR (date_closed IS NULL AND date_execution < ?)", Date.today).size
      @orders_for_closing = Order.includes(:shop, :category, :status, :users, :performers,
                          :executions, :reworks).where("date_closed is null and status_id = ?", Status::COORDINATION).
                            joins(:executions).distinct.size
      @orders_agree = Order.includes(:shop, :category, :status, :users, :performers,
                          :executions, :reworks).where("date_closed is null and status_id = ?", Status::AGREE).
                            joins(:executions).distinct.size
      @orders_not_coordination = Order.includes(:shop, :category, :status, :users, :performers,
                                 :executions, :reworks).where("date_closed is null and status_id = ?",
                                  Status::NOT_COORDINATION).joins(:executions).distinct.size
      @orders_count = Order.includes(:shop, :category, :status, :users, :performers,
                          :executions, :reworks).size
    else
      @q = current_user.orders.includes(:shop, :category, :status, :users, :performers,
                          :executions, :reworks).ransack(params[:q])
      @orders_closed = current_user.orders.includes(:shop, :category, :status, :users, :performers,
                          :executions, :reworks).size
      @orders_open = current_user.orders.includes(:shop, :category, :status, :users, :performers,
                          :executions, :reworks).where("date_closed is null and status_id = ?", Status::EXECUTION).size
      @orders_overdue = current_user.orders.includes(:shop, :category, :status, :users, :performers,
                          :executions, :reworks).where("(date_closed > date_execution) OR
                          (date_closed IS NULL AND date_execution < ?)", Date.today).size
      @orders_coordination = current_user.orders.includes(:shop, :category, :status, :users, :performers,
                          :executions, :reworks).where("date_closed is null and status_id = ?", Status::AGREE).
                            joins(:executions).distinct.size
      @orders_not_coordination = current_user.orders.includes(:shop, :category, :status, :users, :performers,
                                  :executions, :reworks).where("date_closed is null and status_id = ?",
                                  Status::NOT_COORDINATION).joins(:executions).distinct.size
      @orders_count = current_user.orders.size
    end
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @orders = @q.result(disinct: true)
  end
end
