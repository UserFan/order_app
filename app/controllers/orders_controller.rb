class OrdersController < ApplicationController

  before_action :set_order, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Order
    @q = Order.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @orders = @q.result(disinct: true)
    @orders_closed = Order.ransack(date_closed_not_null: '1').result.count
    @orders_open = Order.ransack(date_closed_not_null: '0').result.count
    @orders_count = Order.count
  end

  def show
    authorize @order
  end

  def new
    authorize Order
    @order = Order.new
  end

  def edit
    authorize @order
  end

  def create
    authorize Order
    @order = Order.new(permitted_attributes(Order))    # Not the final implementation!
    if @order.save
      redirect_to orders_path
    else
      render 'new'
    end
  end

  def update
    authorize @order
    if @order.update_attributes(permitted_attributes(@order))
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
    @order = Order.find(params[:id])
  end
end
