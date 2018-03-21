class OrdersController < ApplicationController
  before_action :set_order, except: [ :index, :new, :create ]
  before_action :set_edit_form, only: [ :edit, :update ]
  before_action :set_index, only: [ :index ]
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
    # binding.pry
    if @order.validate(params[:order])
      @order.save
      redirect_to orders_path
    else
      render 'edit'
    end
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
  end

  def set_edit_form
    @order = OrderForm.new(Order.find(params[:id]))
  end

  def set_index
    if current_user.super_admin? || current_user.moderator?
      @q = Order.includes(:shop, :category, :status, :users).ransack(params[:q])
      @orders_closed = Order.includes(:shop, :category, :status, :users).
                       where.not(date_closed: nil).size
      @orders_open = Order.includes(:shop, :category, :status, :users).
                     where(date_closed: nil).size
      @orders_overdue = Order.includes(:shop, :category, :status, :users).
                        where("date_closed IS NULL AND date_execution < ?", Date.today).size
      @orders_for_closing = Order.includes(:shop, :category, :status, :users).
                            where("date_closed is null and executions.comment is not null").
                            joins(:executions).distinct.size
      @orders_count = Order.count
    else
      @q = current_user.orders.includes(:shop, :category, :status, :users).
           ransack(params[:q])
      @orders_closed = current_user.orders.includes(:shop, :category, :status, :users).
                       where.not(date_closed: nil).size
      @orders_open = current_user.orders.includes(:shop, :category, :status, :users).
                     where(date_closed: nil).size
      @orders_overdue = current_user.orders.includes(:shop, :category, :status, :users).
                        where("date_closed IS NULL AND date_execution < ?", Date.today).size
      @orders_count = current_user.orders.count
    end
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @orders = @q.result(disinct: true)
  end
end
